require 'spec_helper'

describe Nokogiri::Streaming::Reader do

  subject do
    Nokogiri::Streaming::Reader
  end

  describe "#on" do
    it 'parses registered paths' do
      doc = StringIO.new %{
        <root>
          <fruit/>
          <fruit/>
          <vegetable id='1'><seed/></vegetable>
          <meat><type>beef</type></meat>
        </root>
      }

      fruits = []
      vegetables = []
      meats = []

      reader = subject.new(doc)
      reader.on('/root/fruit') do |e|
        fruits.push(e.to_xml(indent: 0))
      end
      reader.on('/root/vegetable') do |e|
        vegetables.push(e.to_xml(indent: 0))
      end
      reader.on('/root/meat/type') do |e|
        meats.push(e.to_xml(indent: 0))
      end
      reader.run

      expect(fruits).to eq ['<fruit/>', '<fruit/>']
      expect(vegetables).to eq ["<vegetable id=\"1\">\n<seed/>\n</vegetable>"]
      expect(meats).to eq ["<type>beef</type>"]
    end

    it 'preserves CDATA nodes' do
      doc = StringIO.new %{
        <root><![CDATA[banana]]></root>
      }

      reader = subject.new(doc)
      reader.on('/root') do |e|
        expect(e.children.length).to eq 1
        expect(e.children.first.cdata?).to be true
      end
      reader.run
    end

    it 'preserves text nodes' do
      doc = StringIO.new %{
        <root>banana</root>
      }

      reader = subject.new(doc)
      reader.on('/root') do |e|
        expect(e.children.length).to eq 1
        expect(e.children.first.text?).to be true
        expect(e.children.first.cdata?).to be false
      end
      reader.run
    end
  end

  describe "#on_start" do
    it 'parses registered paths' do
      doc = StringIO.new %{
        <root>
          <fruit name="apple"/>
          <fruit/>
          <fruit>something</fruit>
          <vegetable id='1'><seed/></vegetable>
          <meat><type>beef</type></meat>
        </root>
      }
      fruits = []
      reader = subject.new(doc)
      reader.on_start('/root/fruit') do |e|
        fruits.push(e.to_xml(indent: 0))
      end
      reader.run

      expect(fruits).to eq ['<fruit name="apple"/>', '<fruit/>', '<fruit/>']
    end
  end

end
