#! /usr/bin/ruby
## -*- cofing:utf-8 -*-
require 'rdf' # RDF.rb 読み込み
require 'rdf/ntriples'
require 'csv'
require 'pp'
include RDF


#uri = RDF::URI.new("http://www.example.org") # 単純なURIの取り込み

=begin
uri = RDF::URI.new({  # URIを組み立てる場合
  :scheme => 'http',
  :host   => 'www.example.org',
  :path   => '/'

})
=end

#uri = uri.to_s # 文字列に変換する場合

#uri = RDF::URI.new("http://www.example.org/bilab/rdf")

=begin
puts uri.absolute?
puts uri.relative?
puts uri.scheme
puts uri.authority
puts uri.host
puts uri.port
puts uri.path
#puts uri.basename # basenameメソッドがない？
=end

=begin
uri = RDF::URI.new("http://www.example.org/")
uri = uri.join("gems", "rdf")
puts uri
puts uri.parernt
puts uri.root
=end

#print uri
#p uri
#puts uri
#
#
#p bnode.id 
#p bnode.to_s



#graph = RDF::Graph.new << [:hello, RDF::DC.title, "Hello, world!"]

#puts graph

#puts term1 = DC.title 
#puts term2 = FOAF.knows


#RDF::Writer.open("hello.nt") do |writer|
#  writer << RDF::Graph.new do |graph|
#    graph << [:hello, RDF::DC.title, "Hello, world!"]
#  end
#end


# UUID使用したブランクノード生成
#bnode = RDF::Node.uuid
#puts bnode.to_s
#bnode2 = RDF::Node.uuid
#puts bnode2.to_s




# アドホックな語彙作成
#foaf = RDF::Vocabulary.new("http://xmlns.com/foaf/0.1/")
#puts foaf.knows    #=> RDF::URI("http://xmlns.com/foaf/0.1/knows")
#puts foaf[:name]   #=> RDF::URI("http://xmlns.com/foaf/0.1/name")
#puts foaf['mbox']  #=> RDF::URI("http://xmlns.com/foaf/0.1/mbox")


#CSV.open(filename, "r", ",") do |row|
#	puts row.to_s
#end
#
#
#tsv = CSV.table('./pdb_chain_scop_uniprot.csv')

#puts tsv[:pdb]



# アドホックな語彙作成
edam = RDF::Vocabulary.new("http://edamontology.org/")
pdbo = RDF::Vocabulary.new("http://rdf.wwpdb.org/schema/pdbx-v40.owl#")
pdbr = RDF::Vocabulary.new("http://rdf.wwpdb.org/pdb/")
up = RDF::Vocabulary.new("http://purl.uniprot.org/core/")
rdf = RDF::Vocabulary.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
idorg = RDF::Vocabulary.new("http://info.identifiers.org/scop/")

#=begin
RDF::Writer.open("hello.nt") do |writer|
# CSVのファイルオープン
CSV.foreach('./scop_header.csv'){|row|
  row0 = row[0].upcase # PDB
  row1 = row[1].upcase # CHAIN
  row2 = row[2].upcase # SP_PRIMARY
  row3 = row[3].upcase # SUNID
  row4 = row[4].upcase # SCOPID

  pdb_resource = pdbr.to_s + row0.to_s + "/struct_asym/" + row1.to_s
  root_uri = RDF::URI.new(pdb_resource)

  sunid = row3.to_s

  writer << RDF::Graph.new do |graph|
    bnode1 = RDF::Node.uuid
    graph.insert([root_uri, RDF::DC.identifier, bnode1])
    graph.insert([bnode1, rdf.type, edam.data_0954])
    graph.insert([bnode1, RDF::RDFS.label, row2.to_s])
    graph.insert([bnode1, RDF::RDFS.label, sunid])
    graph.insert([bnode1, RDF::RDFS.label, row4.to_s])
  end
}
end



#=end
