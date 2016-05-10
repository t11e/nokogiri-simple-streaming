require 'nokogiri'

module Nokogiri
  module Streaming

    # IO wrapper which traps stream exceptions. This works around bug in Nokogiri's
    # SAX code, which seems to ignore exceptions entirely.
    class IOWrapper
      def initialize(source)
        @source = source
      end

      def read(length = nil)
        begin
          return @source.read(length)
        rescue => e
          @exception = e
          raise
        end
      end

      def close
        @stream.close
      end

      attr_reader :exception
    end

    class ParseError < StandardError; end

    class Reader < XML::SAX::Document

      def initialize(source)
        @source = IOWrapper.new(source)
        @parser = Nokogiri::XML::SAX::Parser.new(self)
        @stack = []
        @triggers = {}
      end

      def run
        @parser.parse(@source)
      end

      def on(path, &block)
        (@triggers[path] ||= []).push(block)
      end

      def current_path
        if @stack.any?
          '/' + @stack.join('/')
        else
          ''
        end
      end

      #
      # The following methods are SAX callbacks from Nokogiri.
      #

      def error(message)
        if @source.exception
          raise @source.exception
        end
        raise ParseError.new(message)
      end

      def end_document
      end

      def start_element(name, attrs = [])
        if @current
          element = @current.document.create_element(name)
          attrs.each do |name, value|
            element[name] = value
          end
          @current.add_child(element)
          @current = element
        elsif @triggers[current_path + '/' + name]
          fragment = Nokogiri::XML::DocumentFragment.new(Nokogiri::XML::Document.new)

          element = fragment.document.create_element(name)
          attrs.each do |name, value|
            element[name] = value
          end
          @current = element
        end
        @stack.push(name)
      end

      def end_element(name)
        path = current_path

        @stack.pop

        element = @current
        if @current
          @current = @current.parent
        end

        triggers = @triggers[path]
        if triggers
          triggers.each do |proc|
            proc.call(element)
          end
        end
      end

      def characters(string)
        if @current
          @current.add_child(string)
        end
      end

      def cdata_block(string)
        if @current
          @current.add_child(@current.document.create_cdata(string))
        end
      end

    end

  end
end
