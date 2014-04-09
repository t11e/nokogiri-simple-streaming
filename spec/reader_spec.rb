require 'spec_helper'

describe Nokogiri::Streaming::Reader do

  subject do
    Nokogiri::Streaming::Reader
  end

  it 'parses registered paths' do
    doc = %{
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

end