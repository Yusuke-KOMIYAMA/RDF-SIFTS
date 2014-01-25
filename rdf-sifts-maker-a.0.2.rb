#! /usr/bin/ruby
## -*- cofing:utf-8 -*-
#  開発に使用したrubyのバージョン
#  ruby 1.9.3p194 (2012-04-20 revision 35410) [x86_64-darwin11.4.0]
#
require 'rdf' 
require 'rdf/ntriples'
require 'csv'
require 'net/ftp'
require 'optparse'
include RDF


class RDFSIFTS
  def scop
#=begin
    #########################################################
    #    FTPを用いてEBIから最新のSIFTSデータを取得
    #########################################################
    print "The obtain of the latest SIFTS SCOP from EBI "
    ftp = Net::FTP.new('ftp.ebi.ac.uk')
    ftp.login
    ftp.passive = true
    ftp.chdir('pub/databases/msd/sifts/text')
    files = ftp.list('*.lst')
    ftp.gettextfile('pdb_chain_scop_uniprot.lst', 'pdb_chain_scop_uniprot.lst')
    ftp.close
    print "was completed!\n"
#=end

#=begin
    #########################################################
    #    RDF.rbでクラス定義されていないPREFIXの読み込み
    #########################################################
    edam = RDF::Vocabulary.new("http://edamontology.org/")
    pdbo = RDF::Vocabulary.new("http://rdf.wwpdb.org/schema/pdbx-v40.owl#")
    pdbr = RDF::Vocabulary.new("http://rdf.wwpdb.org/pdb/")
    up = RDF::Vocabulary.new("http://purl.uniprot.org/core/")
    upr = RDF::Vocabulary.new("http://www.uniprot.org/uniprot/")
    rdf = RDF::Vocabulary.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
    idorg = RDF::Vocabulary.new("http://info.identifiers.org/")

    #########################################################
    #   RDFのグラフモデルの組み立て 『RDF-SIFTS SCOP』 
    #########################################################
    print "The transformation of RDF-SIFTS SCOP "
    RDF::Writer.open("pdb_chain_scop_uniprot.nt") do |writer|
      CSV.foreach('./pdb_chain_scop_uniprot.lst', headers:true, col_sep:'	') {|row|
        row0 = row[0].upcase # PDB
        row1 = row[1].upcase # CHAIN
        row2 = row[2].upcase # SP_PRIMARY
        row3 = row[3].upcase # SUNID
        row4 = row[4] # SCOPID

        if /^#/ =~ row0
        else
          pdb_resource = pdbr.to_s + row0.to_s + "/struct_asym/" + row1.to_s
          root_uri = RDF::URI.new(pdb_resource)

          uniprotac = upr.to_s + row2.to_s
          upac_uri = RDF::URI.new(uniprotac)

          sunid = idorg.to_s + "scop/" + row3.to_s
          sunid_uri = RDF::URI.new(sunid)

          writer << RDF::Graph.new do |graph|
            bnode1 = RDF::Node.uuid.to_s.insert(0,"genid").delete("-").delete("_:")
	    bnode1 = RDF::Node.new(bnode1)
            graph.insert([root_uri, RDF::DC.identifier, bnode1])
              graph.insert([bnode1, rdf.type, edam.data_0954])
              graph.insert([bnode1, edam.has_identifier, upac_uri])
                graph.insert([upac_uri, rdf.type, up.Protein])
              graph.insert([bnode1, edam.has_identifier, sunid_uri])
	        graph.insert([sunid_uri, rdf.type, edam.data_1042])
              bnode2 = RDF::Node.uuid.to_s.insert(0,"genid").delete("-").delete("_:")
	      bnode2 = RDF::Node.new(bnode2)
              graph.insert([bnode1, edam.has_identifier, bnode2])
                graph.insert([bnode2, rdf.type, edam.data_1039])
                graph.insert([bnode2, RDF::RDFS.label, row4.to_s])
          end
        end
      }
    end
    print "was completed!\n"
#=end
  end

  def cath
#=begin
    #########################################################
    #    FTPを用いてEBIから最新のSIFTSデータを取得
    #########################################################
    print "The obtain of the latest SIFTS CATH from EBI "
    ftp = Net::FTP.new('ftp.ebi.ac.uk')
    ftp.login
    ftp.passive = true
    ftp.chdir('pub/databases/msd/sifts/text')
    files = ftp.list('*.lst')
    ftp.gettextfile('pdb_chain_cath_uniprot.lst', 'pdb_chain_cath_uniprot.lst')
    ftp.close
    print "was completed!\n"
#=end

#=begin
    #########################################################
    #    RDF.rbでクラス定義されていないPREFIXの読み込み
    #########################################################
    edam = RDF::Vocabulary.new("http://edamontology.org/")
    pdbo = RDF::Vocabulary.new("http://rdf.wwpdb.org/schema/pdbx-v40.owl#")
    pdbr = RDF::Vocabulary.new("http://rdf.wwpdb.org/pdb/")
    up = RDF::Vocabulary.new("http://purl.uniprot.org/core/")
    upr = RDF::Vocabulary.new("http://www.uniprot.org/uniprot/")
    rdf = RDF::Vocabulary.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
    idorg = RDF::Vocabulary.new("http://info.identifiers.org/")

    #########################################################
    #   RDFのグラフモデルの組み立て 『RDF-SIFTS CATH』 
    #########################################################
    print "The transformation of RDF-SIFTS CATH "
    RDF::Writer.open("pdb_chain_cath_uniprot.nt") do |writer|
      CSV.foreach('./pdb_chain_cath_uniprot.lst', headers:true, col_sep:'	') {|row|
        row0 = row[0].upcase # PDB
        row1 = row[1].upcase # CHAIN
        row2 = row[2].upcase # SP_PRIMARY
        row3 = row[3].upcase # CATH_ID

        if /^#/ =~ row0
        else
          pdb_resource = pdbr.to_s + row0.to_s + "/struct_asym/" + row1.to_s
          root_uri = RDF::URI.new(pdb_resource)

          uniprotac = upr.to_s + row2.to_s
          upac_uri = RDF::URI.new(uniprotac)

          cath_domain_id = idorg.to_s + "cath.domain/" + row3.to_s
          cath_domain_id_uri = RDF::URI.new(cath_domain_id)

          writer << RDF::Graph.new do |graph|
            bnode1 = RDF::Node.uuid.to_s.insert(0,"genid").delete("-").delete("_:")
	    bnode1 = RDF::Node.new(bnode1)
            graph.insert([root_uri, RDF::DC.identifier, bnode1])
	      graph.insert([bnode1, rdf.type, edam.data_0954])
              graph.insert([bnode1, edam.has_identifier, upac_uri])
                graph.insert([upac_uri, rdf.type, up.Protein])
              graph.insert([bnode1, edam.has_identifier, cath_domain_id_uri])	      
	        graph.insert([cath_domain_id_uri, rdf.type, edam.data_1040])
          end
        end
      }
    end
    print "was completed!\n"
#=end
  end


end



#########################################################
#   コマンドラインオプション
#########################################################
opts = OptionParser.new
opts.banner = "Usage: rdf-sifts-maker.rb [options]"

opts.separator ""
opts.separator "Specific options:"

opts.on("-s", "--scop", "convert to the RDF-SIFTS SCOP from the latest EBI SIFTS.") do |scop|
  run = RDFSIFTS.new
  run.scop
end

opts.on("-c", "--cath", "convert to the RDF-SIFTS CATH from the latest EBI SIFTS.") do |pubmed|
  run = RDFSIFTS.new
  run.cath
end

opts.separator ""
opts.separator "Common options:"

opts.on_tail("-h", "--help", "show this message") do
  puts opts
  exit
end

opts.parse!(ARGV)    



