# Simple streaming reader for Nokogiri

This library implements a very simple streaming parser that can parse large documents with low memory overhead.

When setting up the reader, one registers paths to capture:

    reader.on('/path') do |e|
      # ...
    end

Each path must be a simple XPath-like path. Unlike XPath, only path segments are currently supported, however. The path must always start at the root.

Each registered handler receives the parsed element as its argument.

## Example

    reader = Nokogiri::Streaming::Reader.new(doc)
    reader.on('/some/element/in/document') do |e|
      # Handle element
    end
    reader.on('/some/other/element/in/document') do |e|
      # Handle element
    end
    reader.run
