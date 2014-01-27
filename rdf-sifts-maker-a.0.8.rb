#! /usr/bin/ruby
## -*- cofing:utf-8 -*-
#
#  『RDF-SIFTS Maker』alpha version 0.8
#   by Yusuke Komiyama
#
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
#########################################################
#    『RDF-SIFTS』クラス
#########################################################

  def scop
  #########################################################
  #    『RDF-SIFTS SCOP』メソッド
  #########################################################
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

          pdb_top = pdbr.to_s + row0.to_s
          pdb_top_uri = RDF::URI.new(pdb_top)

          uniprotac = upr.to_s + row2.to_s
          upac_uri = RDF::URI.new(uniprotac)

          sunid = idorg.to_s + "scop/" + row3.to_s
          sunid_uri = RDF::URI.new(sunid)

          writer << RDF::Graph.new do |graph|
            bnode1 = RDF::Node.uuid.to_s.insert(0,"genid").delete("-").delete("_:")
	    bnode1 = RDF::Node.new(bnode1)
	    graph.insert([root_uri, rdf.type, edam.data_1008])
            graph.insert([root_uri, pdbo.of_datablock, pdb_top_uri])
	      graph.insert([pdb_top_uri, rdf.type, edam.data_1127])
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
  #########################################################
  #    『RDF-SIFTS CATH』メソッド
  #########################################################
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

          pdb_top = pdbr.to_s + row0.to_s
          pdb_top_uri = RDF::URI.new(pdb_top)

          uniprotac = upr.to_s + row2.to_s
          upac_uri = RDF::URI.new(uniprotac)

          cath_domain_id = idorg.to_s + "cath.domain/" + row3.to_s
          cath_domain_id_uri = RDF::URI.new(cath_domain_id)

          writer << RDF::Graph.new do |graph|
            bnode1 = RDF::Node.uuid.to_s.insert(0,"genid").delete("-").delete("_:")
	    bnode1 = RDF::Node.new(bnode1)
	    graph.insert([root_uri, rdf.type, edam.data_1008])
            graph.insert([root_uri, pdbo.of_datablock, pdb_top_uri])
	      graph.insert([pdb_top_uri, rdf.type, edam.data_1127])
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


  def pubmed
  #########################################################
  #    『RDF-SIFTS PubMed』メソッド
  #########################################################
#=begin
    #########################################################
    #    FTPを用いてEBIから最新のSIFTSデータを取得
    #########################################################
    print "The obtain of the latest SIFTS PubMed from EBI "
    ftp = Net::FTP.new('ftp.ebi.ac.uk')
    ftp.login
    ftp.passive = true
    ftp.chdir('pub/databases/msd/sifts/text')
    files = ftp.list('*.lst')
    ftp.gettextfile('pdb_pubmed.lst', 'pdb_pubmed.lst')
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
    rdf = RDF::Vocabulary.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
    idorg = RDF::Vocabulary.new("http://info.identifiers.org/")
    sio = RDF::Vocabulary.new("http://semanticscience.org/resource/")

    #########################################################
    #   RDFのグラフモデルの組み立て 『RDF-SIFTS PubMed』 
    #########################################################
    print "The transformation of RDF-SIFTS PubMed "
    RDF::Writer.open("pdb_pubmed.nt") do |writer|
      CSV.foreach('./pdb_pubmed.lst', headers:true, col_sep:'	') {|row|
        row0 = row[0].upcase # PDB
        row1 = row[1].upcase # ORDINAL
        row2 = row[2].upcase # PUBMED_ID

        if /^#/ =~ row0
        else
          pdb_top = pdbr.to_s + row0.to_s
          pdb_top_uri = RDF::URI.new(pdb_top)

	  if row1.to_i == 0
            pdb_citation = pdbr.to_s + row0.to_s + "/citation/" + "primary"
            pdb_citation_uri = RDF::URI.new(pdb_citation)
          else
            pdb_citation = pdbr.to_s + row0.to_s + "/citation/" + row1.to_s
            pdb_citation_uri = RDF::URI.new(pdb_citation)
          end

          pdb_citation_id_property = pdbo.to_s + "citation.id"
	  pdb_citation_id_property_uri = RDF::URI.new(pdb_citation_id_property)

          pmid = idorg.to_s + "pubmed/" + row2.to_s
          pmid_uri = RDF::URI.new(pmid)

          writer << RDF::Graph.new do |graph|
            bnode1 = RDF::Node.uuid.to_s.insert(0,"genid").delete("-").delete("_:")
	    bnode1 = RDF::Node.new(bnode1)
            graph.insert([pdb_top_uri, RDF::DC.identifier, bnode1])
            graph.insert([pdb_top_uri, rdf.type, edam.data_1127])
              graph.insert([bnode1, pdb_citation_id_property_uri, pdb_citation_uri])
	        graph.insert([pdb_citation_uri, sio.SIO_000628, pmid_uri])
                  graph.insert([pmid_uri, rdf.type, edam.data_1187])
          end
        end
      }
    end
    print "was completed!\n"
#=end
  end

  #########################################################
  #    『RDF-SIFTS Taxonomy』メソッド
  #########################################################
  def taxonomy
#=begin
    #########################################################
    #    FTPを用いてEBIから最新のSIFTSデータを取得
    #########################################################
    print "The obtain of the latest SIFTS Taxonomy from EBI "
    ftp = Net::FTP.new('ftp.ebi.ac.uk')
    ftp.login
    ftp.passive = true
    ftp.chdir('pub/databases/msd/sifts/text')
    files = ftp.list('*.lst')
    ftp.gettextfile('pdb_chain_taxonomy.lst', 'pdb_chain_taxonomy.lst')
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
    rdf = RDF::Vocabulary.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
    idorg = RDF::Vocabulary.new("http://info.identifiers.org/")

    #########################################################
    #   RDFのグラフモデルの組み立て 『RDF-SIFTS Taxonomy』 
    #########################################################
    print "The transformation of RDF-SIFTS Taxonomy "
    RDF::Writer.open("pdb_chain_taxonomy.nt") do |writer|
      CSV.foreach('./pdb_chain_taxonomy.lst', headers:true, col_sep:'	') {|row|
        row0 = row[0].upcase # PDB
        row1 = row[1].upcase # CHAIN
        row2 = row[2].upcase # TAX_ID
        row3 = row[3] # SCIENTIFIC_NAME

        if /^#/ =~ row0
        else
          pdb_resource = pdbr.to_s + row0.to_s + "/struct_asym/" + row1.to_s
          root_uri = RDF::URI.new(pdb_resource)

          pdb_top = pdbr.to_s + row0.to_s
          pdb_top_uri = RDF::URI.new(pdb_top)

          taxonomy_id = idorg.to_s + "taxonomy/" + row2.to_s
          taxonomy_id_uri = RDF::URI.new(taxonomy_id)

          writer << RDF::Graph.new do |graph|
            bnode1 = RDF::Node.uuid.to_s.insert(0,"genid").delete("-").delete("_:")
	    bnode1 = RDF::Node.new(bnode1)
	    graph.insert([root_uri, rdf.type, edam.data_1008])
            graph.insert([root_uri, pdbo.of_datablock, pdb_top_uri])
	      graph.insert([pdb_top_uri, rdf.type, edam.data_1127])
            graph.insert([root_uri, RDF::DC.identifier, bnode1])
	      graph.insert([bnode1, rdf.type, edam.data_0954])
              graph.insert([bnode1, edam.has_identifier, taxonomy_id_uri])
	        graph.insert([taxonomy_id_uri, rdf.type, edam.data_1179])
	        graph.insert([taxonomy_id_uri, RDF::RDFS.label, row3.to_s])
          end
        end
      }
    end
    print "was completed!\n"
#=end
  end

  def uniprot
  #########################################################
  #    『RDF-SIFTS UniProt』メソッド
  #########################################################
#=begin
    #########################################################
    #    FTPを用いてEBIから最新のSIFTSデータを取得
    #########################################################
    print "The obtain of the latest SIFTS UniProt from EBI "
    ftp = Net::FTP.new('ftp.ebi.ac.uk')
    ftp.login
    ftp.passive = true
    ftp.chdir('pub/databases/msd/sifts/text')
    files = ftp.list('*.lst')
    ftp.gettextfile('pdb_chain_uniprot.lst', 'pdb_chain_uniprot.lst')
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
    faldo = RDF::Vocabulary.new("http://biohackathon.org/resource/faldo#")

    #########################################################
    #   RDFのグラフモデルの組み立て 『RDF-SIFTS UniProt』 
    #########################################################
    print "The transformation of RDF-SIFTS UniProt "
    RDF::Writer.open("pdb_chain_uniprot.nt") do |writer|
      CSV.foreach('./pdb_chain_uniprot.lst', headers:true, col_sep:'	') {|row|
        row0 = row[0].upcase # PDB
        row1 = row[1].upcase # CHAIN
        row2 = row[2].upcase # SP_PRIMARY
        row3 = row[3] # RES_BEG
        row4 = row[4] # RES_END
        row5 = row[5] # PDB_BEG
        row6 = row[6] # PDB_END
        row7 = row[7] # SP_BEG
        row8 = row[8] # SP_END

        if /^#/ =~ row0
        else
          pdb_resource = pdbr.to_s + row0.to_s + "/struct_asym/" + row1.to_s
          root_uri = RDF::URI.new(pdb_resource)

          pdb_top = pdbr.to_s + row0.to_s
          pdb_top_uri = RDF::URI.new(pdb_top)

          uniprotac = upr.to_s + row2.to_s
          upac_uri = RDF::URI.new(uniprotac)

          writer << RDF::Graph.new do |graph|
            # UniProt
            bnode1 = RDF::Node.uuid.to_s.insert(0,"genid").delete("-").delete("_:")
	    bnode1 = RDF::Node.new(bnode1)
	    graph.insert([root_uri, rdf.type, edam.data_1008])
            graph.insert([root_uri, pdbo.of_datablock, pdb_top_uri])
	      graph.insert([pdb_top_uri, rdf.type, edam.data_1127])
            graph.insert([root_uri, RDF::DC.identifier, bnode1])
	      graph.insert([bnode1, rdf.type, edam.data_0954])
              graph.insert([bnode1, edam.has_identifier, upac_uri])
                graph.insert([upac_uri, rdf.type, up.Protein])
	      bnode2 = RDF::Node.uuid.to_s.insert(0,"genid").delete("-").delete("_:")
	      bnode2 = RDF::Node.new(bnode2)
	      graph.insert([bnode1, faldo.location, bnode2])
		graph.insert([bnode2, rdf.type, faldo.Region])
		graph.insert([bnode2, rdf.type, up.Range])
		  bnode3 = RDF::Node.uuid.to_s.insert(0,"genid").delete("-").delete("_:")
	          bnode3 = RDF::Node.new(bnode3)
		  graph.insert([bnode2, faldo.begin, bnode3])
		    graph.insert([bnode3, rdf.type, faldo.Position])
		    graph.insert([bnode3, RDF::RDFS.label, row7])
		  bnode4 = RDF::Node.uuid.to_s.insert(0,"genid").delete("-").delete("_:")
	          bnode4 = RDF::Node.new(bnode4)
		  graph.insert([bnode2, faldo.begin, bnode4])
		    graph.insert([bnode4, rdf.type, faldo.Position])
		    graph.insert([bnode4, RDF::RDFS.label, row8])
	      # PDB SEQRES
	      bnode5 = RDF::Node.uuid.to_s.insert(0,"genid").delete("-").delete("_:")
	      bnode5 = RDF::Node.new(bnode5)
	      graph.insert([bnode1, faldo.location, bnode5])
		graph.insert([bnode5, rdf.type, faldo.Region])
		graph.insert([bnode5, rdf.type, edam.format_1953])
		  bnode6 = RDF::Node.uuid.to_s.insert(0,"genid").delete("-").delete("_:")
	          bnode6 = RDF::Node.new(bnode6)
	          graph.insert([bnode5, faldo.begin, bnode6])
		    graph.insert([bnode6, rdf.type, faldo.Position])
		    graph.insert([bnode6, RDF::RDFS.label, row3])
		  bnode7 = RDF::Node.uuid.to_s.insert(0,"genid").delete("-").delete("_:")
	          bnode7 = RDF::Node.new(bnode7)
		  graph.insert([bnode5, faldo.begin, bnode7])
		    graph.insert([bnode7, rdf.type, faldo.Position])
		    graph.insert([bnode7, RDF::RDFS.label, row4])
	      # PDB ATOM 
	      bnode8 = RDF::Node.uuid.to_s.insert(0,"genid").delete("-").delete("_:")
	      bnode8 = RDF::Node.new(bnode8)
	      graph.insert([bnode1, faldo.location, bnode8])
		graph.insert([bnode8, rdf.type, faldo.Region])
		graph.insert([bnode8, rdf.type, edam.format_1950])
		  bnode9 = RDF::Node.uuid.to_s.insert(0,"genid").delete("-").delete("_:")
	          bnode9 = RDF::Node.new(bnode9)
	          graph.insert([bnode8, faldo.begin, bnode9])
		    graph.insert([bnode9, rdf.type, faldo.Position])
		    graph.insert([bnode9, RDF::RDFS.label, row5])
		  bnode10 = RDF::Node.uuid.to_s.insert(0,"genid").delete("-").delete("_:")
	          bnode10 = RDF::Node.new(bnode10)
		  graph.insert([bnode8, faldo.begin, bnode10])
		    graph.insert([bnode10, rdf.type, faldo.Position])
		    graph.insert([bnode10, RDF::RDFS.label, row6])
          end
        end
      }
    end
    print "was completed!\n"
#=end
  end

  def interpro
  #########################################################
  #    『RDF-SIFTS InterPro』メソッド
  #########################################################
#=begin
    #########################################################
    #    FTPを用いてEBIから最新のSIFTSデータを取得
    #########################################################
    print "The obtain of the latest SIFTS InterPro from EBI "
    ftp = Net::FTP.new('ftp.ebi.ac.uk')
    ftp.login
    ftp.passive = true
    ftp.chdir('pub/databases/msd/sifts/text')
    files = ftp.list('*.lst')
    ftp.gettextfile('pdb_chain_interpro.lst', 'pdb_chain_interpro.lst')
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
    rdf = RDF::Vocabulary.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
    idorg = RDF::Vocabulary.new("http://info.identifiers.org/")

    #########################################################
    #   RDFのグラフモデルの組み立て 『RDF-SIFTS InterPro』 
    #########################################################
    print "The transformation of RDF-SIFTS InterPro "
    RDF::Writer.open("pdb_chain_interpro.nt") do |writer|
      CSV.foreach('./pdb_chain_interpro.lst', headers:true, col_sep:'	') {|row|
        row0 = row[0].upcase # PDB
        row1 = row[1].upcase # CHAIN
        row2 = row[2].upcase # INTERPRO_ID

        if /^#/ =~ row0
        else
          pdb_resource = pdbr.to_s + row0.to_s + "/struct_asym/" + row1.to_s
          root_uri = RDF::URI.new(pdb_resource)

          pdb_top = pdbr.to_s + row0.to_s
          pdb_top_uri = RDF::URI.new(pdb_top)

          interpro_id = idorg.to_s + "interpro/" + row2.to_s
          interpro_id_uri = RDF::URI.new(interpro_id)

          writer << RDF::Graph.new do |graph|
            bnode1 = RDF::Node.uuid.to_s.insert(0,"genid").delete("-").delete("_:")
	    bnode1 = RDF::Node.new(bnode1)
	    graph.insert([root_uri, rdf.type, edam.data_1008])
            graph.insert([root_uri, pdbo.of_datablock, pdb_top_uri])
	      graph.insert([pdb_top_uri, rdf.type, edam.data_1127])
            graph.insert([root_uri, RDF::DC.identifier, bnode1])
	      graph.insert([bnode1, rdf.type, edam.data_0954])
              graph.insert([bnode1, edam.has_identifier, interpro_id_uri])
                graph.insert([interpro_id_uri, rdf.type, edam.data_1133])
          end
        end
      }
    end
    print "was completed!\n"
#=end
  end

  def go
  #########################################################
  #    『RDF-SIFTS GO』メソッド
  #########################################################
#=begin
    #########################################################
    #    FTPを用いてEBIから最新のSIFTSデータを取得
    #########################################################
    print "The obtain of the latest SIFTS GO from EBI "
    ftp = Net::FTP.new('ftp.ebi.ac.uk')
    ftp.login
    ftp.passive = true
    ftp.chdir('pub/databases/msd/sifts/text')
    files = ftp.list('*.lst')
    ftp.gettextfile('pdb_chain_go.lst', 'pdb_chain_go.lst')
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
    biopax = RDF::Vocabulary.new("http://www.biopax.org/release/biopax-level3.owl#")

    #########################################################
    #   RDFのグラフモデルの組み立て 『RDF-SIFTS GO』 
    #########################################################
    print "The transformation of RDF-SIFTS GO "
    RDF::Writer.open("pdb_chain_go.nt") do |writer|
      CSV.foreach('./pdb_chain_go.lst', headers:true, col_sep:'	') {|row|
        row0 = row[0].upcase # PDB
        row1 = row[1].upcase # CHAIN
        row2 = row[2].upcase # SP_PRIMARY
        row3 = row[3] # WITH_STRING
        row4 = row[4] # EVIDENCE
        row5 = row[5] # GO_ID


        if /^#/ =~ row0
        else
          pdb_resource = pdbr.to_s + row0.to_s + "/struct_asym/" + row1.to_s
          root_uri = RDF::URI.new(pdb_resource)

          pdb_top = pdbr.to_s + row0.to_s
          pdb_top_uri = RDF::URI.new(pdb_top)

	  if row2 == "IPRO"
	    uniprotac = idorg.to_s + "interpro/"
            upac_uri = RDF::URI.new(uniprotac)
          else
	    uniprotac = upr.to_s + row2.to_s
            upac_uri = RDF::URI.new(uniprotac)
          end

	  go_id = idorg.to_s + "go/" + row5.to_s
          go_id_uri = RDF::URI.new(go_id)


          writer << RDF::Graph.new do |graph|
            bnode1 = RDF::Node.uuid.to_s.insert(0,"genid").delete("-").delete("_:")
	    bnode1 = RDF::Node.new(bnode1)
	    graph.insert([root_uri, rdf.type, edam.data_1008])
            graph.insert([root_uri, pdbo.of_datablock, pdb_top_uri])
	      graph.insert([pdb_top_uri, rdf.type, edam.data_1127])
            graph.insert([root_uri, RDF::DC.identifier, bnode1])
	      graph.insert([bnode1, rdf.type, edam.data_0954])
	      graph.insert([bnode1, edam.has_identifier, upac_uri])
                graph.insert([upac_uri, rdf.type, up.Protein])
	      graph.insert([bnode1, RDF::RDFS.comment, row3])
              bnode2 = RDF::Node.uuid.to_s.insert(0,"genid").delete("-").delete("_:")
	      bnode2 = RDF::Node.new(bnode2)
	      grapn.insert([bnode1, biopax.evidenceCode, bnode2])
	      grapn.insert([bnode1, rdf.type, biopax.Evidence])
	        graph.insert([bnode2, RDF::RDFS.label, row5])
                graph.insert([bnode2, rdf.type, biopax.EvidenceCodeVocabulary])
	      graph.insert([bnode1, edam.has_identifier, go_id_uri])
                graph.insert([go_id_uri, rdf.type, edam.data_1176])
          end
        end
      }
    end
    print "was completed!\n"
#=end
  end

  def pfam
  #########################################################
  #    『RDF-SIFTS Pfam』メソッド
  #########################################################
#=begin
    #########################################################
    #    FTPを用いてEBIから最新のSIFTSデータを取得
    #########################################################
    print "The obtain of the latest SIFTS Pfam from EBI "
    ftp = Net::FTP.new('ftp.ebi.ac.uk')
    ftp.login
    ftp.passive = true
    ftp.chdir('pub/databases/msd/sifts/text')
    files = ftp.list('*.lst')
    ftp.gettextfile('pdb_chain_pfam.lst', 'pdb_chain_pfam.lst')
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
    #   RDFのグラフモデルの組み立て 『RDF-SIFTS Pfam』 
    #########################################################
    print "The transformation of RDF-SIFTS Pfam "
    RDF::Writer.open("pdb_chain_pfam.nt") do |writer|
      CSV.foreach('./pdb_chain_pfam.lst', headers:true, col_sep:'	') {|row|
        row0 = row[0].upcase # PDB
        row1 = row[1].upcase # CHAIN
        row2 = row[2].upcase # SP_PRIMARY
        row3 = row[3].upcase # PFAM_ID

        if /^#/ =~ row0
        else
          pdb_resource = pdbr.to_s + row0.to_s + "/struct_asym/" + row1.to_s
          root_uri = RDF::URI.new(pdb_resource)

          pdb_top = pdbr.to_s + row0.to_s
          pdb_top_uri = RDF::URI.new(pdb_top)

          uniprotac = upr.to_s + row2.to_s
          upac_uri = RDF::URI.new(uniprotac)

          pfam_id = idorg.to_s + "pfam/" + row3.to_s
          pfam_id_uri = RDF::URI.new(pfam_id)

          writer << RDF::Graph.new do |graph|
            bnode1 = RDF::Node.uuid.to_s.insert(0,"genid").delete("-").delete("_:")
	    bnode1 = RDF::Node.new(bnode1)
	    graph.insert([root_uri, rdf.type, edam.data_1008])
            graph.insert([root_uri, pdbo.of_datablock, pdb_top_uri])
	      graph.insert([pdb_top_uri, rdf.type, edam.data_1127])
            graph.insert([root_uri, RDF::DC.identifier, bnode1])
	      graph.insert([bnode1, rdf.type, edam.data_0954])
	      graph.insert([bnode1, edam.has_identifier, upac_uri])
                graph.insert([upac_uri, rdf.type, up.Protein])
	      graph.insert([bnode1, edam.has_identifier, pfam_id_uri])
                graph.insert([pfam_id_uri, rdf.type, edam.data_1138])
          end
        end
      }
    end
    print "was completed!\n"
#=end
  end

  def enzyme
  #########################################################
  #    『RDF-SIFTS Enzyme』メソッド
  #########################################################
#=begin
    #########################################################
    #    FTPを用いてEBIから最新のSIFTSデータを取得
    #########################################################
    print "The obtain of the latest SIFTS Enzyme from EBI "
    ftp = Net::FTP.new('ftp.ebi.ac.uk')
    ftp.login
    ftp.passive = true
    ftp.chdir('pub/databases/msd/sifts/text')
    files = ftp.list('*.lst')
    ftp.gettextfile('pdb_chain_enzyme.lst', 'pdb_chain_enzyme.lst')
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
    dbp = RDF::Vocabulary.new("http://dbpedia.org/resource/")

    #########################################################
    #   RDFのグラフモデルの組み立て 『RDF-SIFTS Enzyme』 
    #########################################################
    print "The transformation of RDF-SIFTS Enzyme "
    RDF::Writer.open("pdb_chain_enzyme.nt") do |writer|
      CSV.foreach('./pdb_chain_enzyme.lst', headers:true, col_sep:'	') {|row|
        row0 = row[0].upcase # PDB
        row1 = row[1].upcase # CHAIN
        row2 = row[2].upcase # ACCESSION
        row3 = row[3].upcase # EC_NUMBER

        if /^#/ =~ row0
        else
          pdb_resource = pdbr.to_s + row0.to_s + "/struct_asym/" + row1.to_s
          root_uri = RDF::URI.new(pdb_resource)

          pdb_top = pdbr.to_s + row0.to_s
          pdb_top_uri = RDF::URI.new(pdb_top)

          if /\w/ =~ row2
	    uniprotac = upr.to_s + row2.to_s
            upac_uri = RDF::URI.new(uniprotac)
	  else
	    uniprotac = dbp.to_s + "N/a"
            upac_uri = RDF::URI.new(uniprotac)
	  end

          ec_code = idorg.to_s + "ec-code/" + row3.to_s
          ec_code_uri = RDF::URI.new(ec_code)

          writer << RDF::Graph.new do |graph|
            bnode1 = RDF::Node.uuid.to_s.insert(0,"genid").delete("-").delete("_:")
	    bnode1 = RDF::Node.new(bnode1)
	    graph.insert([root_uri, rdf.type, edam.data_1008])
            graph.insert([root_uri, pdbo.of_datablock, pdb_top_uri])
	      graph.insert([pdb_top_uri, rdf.type, edam.data_1127])
            graph.insert([root_uri, RDF::DC.identifier, bnode1])
	      graph.insert([bnode1, rdf.type, edam.data_0954])
	      graph.insert([bnode1, edam.has_identifier, upac_uri])
	        if /\w/ =~ row2
                  graph.insert([upac_uri, rdf.type, up.Protein])
		else
		end
	      graph.insert([bnode1, edam.has_identifier, ec_code_uri])
                graph.insert([ec_code_uri, rdf.type, edam.data_1011])
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

opts.on("-a", "--all", "convert to the all RDF-SIFTS.") do |all|
  run = RDFSIFTS.new
  run.cath
  run.enzyme
  run.go
  run.interpro
  run.pubmed
  run.pfam
  run.scop
  run.taxonomy
  run.uniprot
end
opts.on("-c", "--cath", "convert to the RDF-SIFTS CATH.") do |cath|
  run = RDFSIFTS.new
  run.cath
end
opts.on("-e", "--enzyme", "convert to the RDF-SIFTS Enzyme.") do |enzyme|
  run = RDFSIFTS.new
  run.enzyme
end
opts.on("-g", "--go", "convert to the RDF-SIFTS GO.") do |go|
  run = RDFSIFTS.new
  run.go
end
opts.on("-i", "--interpro", "convert to the RDF-SIFTS InterPro.") do |interpro|
  run = RDFSIFTS.new
  run.interpro
end
opts.on("-m", "--pubmed", "convert to the RDF-SIFTS PubMed.") do |pubmed|
  run = RDFSIFTS.new
  run.pubmed
end
opts.on("-p", "--pfam", "convert to the RDF-SIFTS Pfam.") do |pfam|
  run = RDFSIFTS.new
  run.pfam
end
opts.on("-s", "--scop", "convert to the RDF-SIFTS SCOP.") do |scop|
  run = RDFSIFTS.new
  run.scop
end
opts.on("-t", "--taxonomy", "convert to the RDF-SIFTS Taxonomy.") do |taxonomy|
  run = RDFSIFTS.new
  run.taxonomy
end
opts.on("-u", "--uniprot", "convert to the RDF-SIFTS UniProt.") do |uniprot|
  run = RDFSIFTS.new
  run.uniprot
end

opts.separator ""
opts.separator "Common options:"

opts.on_tail("-h", "--help", "show this message") do
  puts opts
  exit
end

opts.parse!(ARGV)    



