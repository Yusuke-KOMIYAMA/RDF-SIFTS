#! /usr/bin/ruby
## -*- cofing:utf-8 -*-
#
#  RDF-SIFTS "Maker"alpha version 0.8
#   by Yusuke Komiyama
#
#  Development environment for RDF-SIFTS
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
#    Class of "RDF-SIFTS"
#########################################################

  def scopGet
  #########################################################
  #    Method of RDF-SIFTS "scopGet"
  #########################################################
#=begin
    #########################################################
    #    Fetch the latest data of SIFTS from EBI using FTP.
    #########################################################
    print "The obtain of the latest SIFTS SCOP from EBI "
    ftp = Net::FTP.new('ftp.ebi.ac.uk')
    ftp.login
    ftp.passive = true
    ftp.chdir('pub/databases/msd/sifts/text')
    files = ftp.list('*.lst')
    ftp.gettextfile('pdb_chain_scop_uniprot.lst', './download/pdb_chain_scop_uniprot.lst')
    ftp.close
    print "was completed!\n"
#=end
  end

  def scopConvert
  #########################################################
  #    Method of RDF-SIFTS "scopConvert"
  #########################################################

#=begin
    #########################################################
    #    Load the undefined Classes into prefix of SPARQL in "RDF.rb".
    #########################################################
    edam = RDF::Vocabulary.new("http://edamontology.org/")
    pdbo = RDF::Vocabulary.new("http://rdf.wwpdb.org/schema/pdbx-v40.owl#")
    pdbr = RDF::Vocabulary.new("http://rdf.wwpdb.org/pdb/")
    up = RDF::Vocabulary.new("http://purl.uniprot.org/core/")
    upr = RDF::Vocabulary.new("http://purl.uniprot.org/uniprot/")
    rdf = RDF::Vocabulary.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
    idorg = RDF::Vocabulary.new("http://info.identifiers.org/")
    ut = RDF::Vocabulary.new("http://utprot.net/")

    #########################################################
    #   Construct the graph model of RDF for "RDF-SIFTS SCOP". 
    #########################################################
    print "The transformation of RDF-SIFTS SCOP "
    RDF::Writer.open("./result/pdb_chain_scop_uniprot.nt") do |writer|
      CSV.foreach('./download/pdb_chain_scop_uniprot.lst', headers:true, col_sep:'	') {|row|
        row0 = row[0].upcase # PDB
        row1 = row[1].upcase # CHAIN
        row2 = row[2].upcase # SP_PRIMARY
        row3 = row[3].upcase # SUNID
        row4 = row[4] # SCOPID

        if /^#/ =~ row0
        else
          pdb_resource = ut.to_s + "pdb/" + row0.to_s + "/auth_asym/" + row1.to_s
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


  def cathGet
  #########################################################
  #    Method of RDF-SIFTS "cathGet"
  #########################################################
#=begin
    #########################################################
    #    Fetch the latest data of SIFTS from EBI using FTP.
    #########################################################
    print "The obtain of the latest SIFTS CATH from EBI "
    ftp = Net::FTP.new('ftp.ebi.ac.uk')
    ftp.login
    ftp.passive = true
    ftp.chdir('pub/databases/msd/sifts/text')
    files = ftp.list('*.lst')
    ftp.gettextfile('pdb_chain_cath_uniprot.lst', './download/pdb_chain_cath_uniprot.lst')
    ftp.close
    print "was completed!\n"
#=end
  end

  def cathConvert
  #########################################################
  #    Method of RDF-SIFTS "cathConvert"
  #########################################################

#=begin
    #########################################################
    #    Load the undefined Classes into prefix of SPARQL in "RDF.rb".
    #########################################################
    edam = RDF::Vocabulary.new("http://edamontology.org/")
    pdbo = RDF::Vocabulary.new("http://rdf.wwpdb.org/schema/pdbx-v40.owl#")
    pdbr = RDF::Vocabulary.new("http://rdf.wwpdb.org/pdb/")
    up = RDF::Vocabulary.new("http://purl.uniprot.org/core/")
    upr = RDF::Vocabulary.new("http://purl.uniprot.org/uniprot/")
    rdf = RDF::Vocabulary.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
    idorg = RDF::Vocabulary.new("http://info.identifiers.org/")
    ut = RDF::Vocabulary.new("http://utprot.net/")

    #########################################################
    #   Construct the graph model of RDF for RDF-SIFTS "CATH" 
    #########################################################
    print "The transformation of RDF-SIFTS CATH "
    RDF::Writer.open("./result/pdb_chain_cath_uniprot.nt") do |writer|
      CSV.foreach('./download/pdb_chain_cath_uniprot.lst', headers:true, col_sep:'	') {|row|
        row0 = row[0].upcase # PDB
        row1 = row[1].upcase # CHAIN
        row2 = row[2].upcase # SP_PRIMARY
        row3 = row[3].upcase # CATH_ID

        if /^#/ =~ row0
        else
          pdb_resource = ut.to_s + "pdb/" + row0.to_s + "/auth_asym/" + row1.to_s	  
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


  def pubmedGet
  #########################################################
  #    Method of RDF-SIFTS "pubmedGet"
  #########################################################
#=begin
    #########################################################
    #    Fetch the latest data of SIFTS from EBI using FTP.
    #########################################################
    print "The obtain of the latest SIFTS PubMed from EBI "
    ftp = Net::FTP.new('ftp.ebi.ac.uk')
    ftp.login
    ftp.passive = true
    ftp.chdir('pub/databases/msd/sifts/text')
    files = ftp.list('*.lst')
    ftp.gettextfile('pdb_pubmed.lst', './download/pdb_pubmed.lst')
    ftp.close
    print "was completed!\n"
#=end
  end

  def pubmedConvert
  #########################################################
  #    Method of RDF-SIFTS "pubmedConvert"
  #########################################################
#
#=begin
    #########################################################
    #    Load the undefined Classes into prefix of SPARQL in "RDF.rb".
    #########################################################
    edam = RDF::Vocabulary.new("http://edamontology.org/")
    pdbo = RDF::Vocabulary.new("http://rdf.wwpdb.org/schema/pdbx-v40.owl#")
    pdbr = RDF::Vocabulary.new("http://rdf.wwpdb.org/pdb/")
    rdf = RDF::Vocabulary.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
    idorg = RDF::Vocabulary.new("http://info.identifiers.org/")
    sio = RDF::Vocabulary.new("http://semanticscience.org/resource/")

    #########################################################
    #   Construct the graph model of RDF for RDF-SIFTS "PubMed" 
    #########################################################
    print "The transformation of RDF-SIFTS PubMed "
    RDF::Writer.open("./result/pdb_pubmed.nt") do |writer|
      CSV.foreach('./download/pdb_pubmed.lst', headers:true, col_sep:'	') {|row|
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

  def taxonomyGet
  #########################################################
  #    Method of RDF-SIFTS "taxonomyGet"
  #########################################################
#=begin
    #########################################################
    #    Fetch the latest data of SIFTS from EBI using FTP.
    #########################################################
    print "The obtain of the latest SIFTS Taxonomy from EBI "
    ftp = Net::FTP.new('ftp.ebi.ac.uk')
    ftp.login
    ftp.passive = true
    ftp.chdir('pub/databases/msd/sifts/text')
    files = ftp.list('*.lst')
    ftp.gettextfile('pdb_chain_taxonomy.lst', './download/pdb_chain_taxonomy.lst')
    ftp.close
    print "was completed!\n"
#=end
  end

  def taxonomyConvert
  #########################################################
  #    Method of RDF-SIFTS "taxonomyConvert"
  #########################################################
#
#=begin
    #########################################################
    #    Load the undefined Classes into prefix of SPARQL in "RDF.rb".
    #########################################################
    edam = RDF::Vocabulary.new("http://edamontology.org/")
    pdbo = RDF::Vocabulary.new("http://rdf.wwpdb.org/schema/pdbx-v40.owl#")
    pdbr = RDF::Vocabulary.new("http://rdf.wwpdb.org/pdb/")
    rdf = RDF::Vocabulary.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
    idorg = RDF::Vocabulary.new("http://info.identifiers.org/")
    ut = RDF::Vocabulary.new("http://utprot.net/")

    #########################################################
    #   Construct the graph model of RDF for RDF-SIFTS "Taxonomy" 
    #########################################################
    print "The transformation of RDF-SIFTS Taxonomy "

    file = File.open("./download/pdb_chain_taxonomy.lst","r").read.gsub('"','|')
    File.open("./download/pdb_chain_taxonomy.lst2","w").write(file)

    RDF::Writer.open("./result//pdb_chain_taxonomy.nt") do |writer|
      CSV.foreach('./download/pdb_chain_taxonomy.lst2', headers:true, col_sep:'	') {|row|
        row0 = row[0].upcase # PDB
        row1 = row[1].upcase # CHAIN
        row2 = row[2].upcase # TAX_ID
        row3 = row[3] # SCIENTIFIC_NAME

        if /^#/ =~ row0
        else
          pdb_resource = ut.to_s + "pdb/" + row0.to_s + "/auth_asym/" + row1.to_s
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

  def uniprotGet
  #########################################################
  #    Method of RDF-SIFTS "uniprotGet"
  #########################################################
#=begin
    #########################################################
    #    Fetch the latest data of SIFTS from EBI using FTP.
    #########################################################
    print "The obtain of the latest SIFTS UniProt from EBI "
    ftp = Net::FTP.new('ftp.ebi.ac.uk')
    ftp.login
    ftp.passive = true
    ftp.chdir('pub/databases/msd/sifts/text')
    files = ftp.list('*.lst')
    ftp.gettextfile('pdb_chain_uniprot.lst', './download/pdb_chain_uniprot.lst')
    ftp.close
    print "was completed!\n"
#=end
  end

  def uniprotConvert
  #########################################################
  #    Method of RDF-SIFTS "uniprotConvert"
  #########################################################
#
#=begin
    #########################################################
    #    Load the undefined Classes into prefix of SPARQL in "RDF.rb".
    #########################################################
    edam = RDF::Vocabulary.new("http://edamontology.org/")
    pdbo = RDF::Vocabulary.new("http://rdf.wwpdb.org/schema/pdbx-v40.owl#")
    pdbr = RDF::Vocabulary.new("http://rdf.wwpdb.org/pdb/")
    up = RDF::Vocabulary.new("http://purl.uniprot.org/core/")
    upr = RDF::Vocabulary.new("http://purl.uniprot.org/uniprot/")
    rdf = RDF::Vocabulary.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
    idorg = RDF::Vocabulary.new("http://info.identifiers.org/")
    faldo = RDF::Vocabulary.new("http://biohackathon.org/resource/faldo#")
    ut = RDF::Vocabulary.new("http://utprot.net/")

    #########################################################
    #   Construct the graph model of RDF for RDF-SIFTS "UniProt" 
    #########################################################
    print "The transformation of RDF-SIFTS UniProt "
    RDF::Writer.open("./result/pdb_chain_uniprot.nt") do |writer|
      CSV.foreach('./download/pdb_chain_uniprot.lst', headers:true, col_sep:'	') {|row|
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
	  pdb_resource = ut.to_s + "pdb/" + row0.to_s + "/auth_asym/" + row1.to_s
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
		  graph.insert([bnode2, faldo.end, bnode4])
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
		  graph.insert([bnode5, faldo.end, bnode7])
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
		  graph.insert([bnode8, faldo.end, bnode10])
		    graph.insert([bnode10, rdf.type, faldo.Position])
		    graph.insert([bnode10, RDF::RDFS.label, row6])
          end
        end
      }
    end
    print "was completed!\n"
#=end
  end

  def interproGet
  #########################################################
  #    Method of RDF-SIFTS "interproGet"
  #########################################################
#=begin
    #########################################################
    #    Fetch the latest data of SIFTS from EBI using FTP.
    #########################################################
    print "The obtain of the latest SIFTS InterPro from EBI "
    ftp = Net::FTP.new('ftp.ebi.ac.uk')
    ftp.login
    ftp.passive = true
    ftp.chdir('pub/databases/msd/sifts/text')
    files = ftp.list('*.lst')
    ftp.gettextfile('pdb_chain_interpro.lst', './download/pdb_chain_interpro.lst')
    ftp.close
    print "was completed!\n"
#=end
  end

  def interproConvert
  #########################################################
  #    Method of RDF-SIFTS "interproConvert"
  #########################################################
#
#=begin
    #########################################################
    #    Load the undefined Classes into prefix of SPARQL in "RDF.rb".
    #########################################################
    edam = RDF::Vocabulary.new("http://edamontology.org/")
    pdbo = RDF::Vocabulary.new("http://rdf.wwpdb.org/schema/pdbx-v40.owl#")
    pdbr = RDF::Vocabulary.new("http://rdf.wwpdb.org/pdb/")
    rdf = RDF::Vocabulary.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
    idorg = RDF::Vocabulary.new("http://info.identifiers.org/")
    ut = RDF::Vocabulary.new("http://utprot.net/")

    #########################################################
    #   Construct the graph model of RDF for RDF-SIFTS "InterPro" 
    #########################################################
    print "The transformation of RDF-SIFTS InterPro "
    RDF::Writer.open("./result/pdb_chain_interpro.nt") do |writer|
      CSV.foreach('./download/pdb_chain_interpro.lst', headers:true, col_sep:'	') {|row|
        row0 = row[0].upcase # PDB
        row1 = row[1].upcase # CHAIN
        row2 = row[2].upcase # INTERPRO_ID

        if /^#/ =~ row0
        else
          pdb_resource = ut.to_s + "pdb/" + row0.to_s + "/auth_asym/" + row1.to_s
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

  def goGet
  #########################################################
  #    Method of RDF-SIFTS "goGet"
  #########################################################
#=begin
    #########################################################
    #    Fetch the latest data of SIFTS from EBI using FTP.
    #########################################################
    print "The obtain of the latest SIFTS GO from EBI "
    ftp = Net::FTP.new('ftp.ebi.ac.uk')
    ftp.login
    ftp.passive = true
    ftp.chdir('pub/databases/msd/sifts/text')
    files = ftp.list('*.lst')
    ftp.gettextfile('pdb_chain_go.lst', './download/pdb_chain_go.lst')
    ftp.close
    print "was completed!\n"
#=end
  end

  def goConvert
  #########################################################
  #    Method of RDF-SIFTS "goConvert"
  #########################################################
#
#=begin
    #########################################################
    #    Load the undefined Classes into prefix of SPARQL in "RDF.rb".
    #########################################################
    edam = RDF::Vocabulary.new("http://edamontology.org/")
    pdbo = RDF::Vocabulary.new("http://rdf.wwpdb.org/schema/pdbx-v40.owl#")
    pdbr = RDF::Vocabulary.new("http://rdf.wwpdb.org/pdb/")
    up = RDF::Vocabulary.new("http://purl.uniprot.org/core/")
    upr = RDF::Vocabulary.new("http://purl.uniprot.org/uniprot/")
    rdf = RDF::Vocabulary.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
    idorg = RDF::Vocabulary.new("http://info.identifiers.org/")
    biopax = RDF::Vocabulary.new("http://www.biopax.org/release/biopax-level3.owl#")
    ut = RDF::Vocabulary.new("http://utprot.net/")

    #########################################################
    #   Construct the graph model of RDF for RDF-SIFTS "GO" 
    #########################################################
    print "The transformation of RDF-SIFTS GO "
    RDF::Writer.open("./result/pdb_chain_go.nt") do |writer|
      CSV.foreach('./download/pdb_chain_go.lst', headers:true, col_sep:'	') {|row|
        row0 = row[0].upcase # PDB
        row1 = row[1].upcase # CHAIN
        row2 = row[2].upcase # SP_PRIMARY
        row3 = row[3] # WITH_STRING
        row4 = row[4] # EVIDENCE
        row5 = row[5] # GO_ID


        if /^#/ =~ row0
        else
	  pdb_resource = ut.to_s + "pdb/" + row0.to_s + "/auth_asym/" + row1.to_s
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
	      graph.insert([bnode1, biopax.evidenceCode, bnode2])
	      graph.insert([bnode1, rdf.type, biopax.Evidence])
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

  def pfamGet
  #########################################################
  #    Method of RDF-SIFTS "pfamGet"
  #########################################################
#=begin
    #########################################################
    #    Fetch the latest data of SIFTS from EBI using FTP.
    #########################################################
    print "The obtain of the latest SIFTS Pfam from EBI "
    ftp = Net::FTP.new('ftp.ebi.ac.uk')
    ftp.login
    ftp.passive = true
    ftp.chdir('pub/databases/msd/sifts/text')
    files = ftp.list('*.lst')
    ftp.gettextfile('pdb_chain_pfam.lst', './download/pdb_chain_pfam.lst')
    ftp.close
    print "was completed!\n"
#=end
  end

  def pfamConvert
  #########################################################
  #    Method of RDF-SIFTS "pfamConvert"
  #########################################################
#
#=begin
    #########################################################
    #    Load the undefined Classes into prefix of SPARQL in "RDF.rb".
    #########################################################
    edam = RDF::Vocabulary.new("http://edamontology.org/")
    pdbo = RDF::Vocabulary.new("http://rdf.wwpdb.org/schema/pdbx-v40.owl#")
    pdbr = RDF::Vocabulary.new("http://rdf.wwpdb.org/pdb/")
    up = RDF::Vocabulary.new("http://purl.uniprot.org/core/")
    upr = RDF::Vocabulary.new("http://purl.uniprot.org/uniprot/")
    rdf = RDF::Vocabulary.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
    idorg = RDF::Vocabulary.new("http://info.identifiers.org/")
    ut = RDF::Vocabulary.new("http://utprot.net/")

    #########################################################
    #   Construct the graph model of RDF for RDF-SIFTS "Pfam" 
    #########################################################
    print "The transformation of RDF-SIFTS Pfam "
    RDF::Writer.open("./result/pdb_chain_pfam.nt") do |writer|
      CSV.foreach('./download/pdb_chain_pfam.lst', headers:true, col_sep:'	') {|row|
        row0 = row[0].upcase # PDB
        row1 = row[1].upcase # CHAIN
        row2 = row[2].upcase # SP_PRIMARY
        row3 = row[3].upcase # PFAM_ID

        if /^#/ =~ row0
        else
	  pdb_resource = ut.to_s + "pdb/" + row0.to_s + "/auth_asym/" + row1.to_s
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

  def enzymeGet
  #########################################################
  #    Method of RDF-SIFTS "enzymeGet"
  #########################################################
#=begin
    #########################################################
    #    Fetch the latest data of SIFTS from EBI using FTP.
    #########################################################
    print "The obtain of the latest SIFTS Enzyme from EBI "
    ftp = Net::FTP.new('ftp.ebi.ac.uk')
    ftp.login
    ftp.passive = true
    ftp.chdir('pub/databases/msd/sifts/text')
    files = ftp.list('*.lst')
    ftp.gettextfile('pdb_chain_enzyme.lst', './download/pdb_chain_enzyme.lst')
    ftp.close
    print "was completed!\n"
#=end
  end

  def enzymeConvert
  #########################################################
  #    Method of RDF-SIFTS "enzymeConvert"
  #########################################################
#
#=begin
    #########################################################
    #    Load the undefined Classes into prefix of SPARQL in "RDF.rb".
    #########################################################
    edam = RDF::Vocabulary.new("http://edamontology.org/")
    pdbo = RDF::Vocabulary.new("http://rdf.wwpdb.org/schema/pdbx-v40.owl#")
    pdbr = RDF::Vocabulary.new("http://rdf.wwpdb.org/pdb/")
    up = RDF::Vocabulary.new("http://purl.uniprot.org/core/")
    upr = RDF::Vocabulary.new("http://purl.uniprot.org/uniprot/")
    rdf = RDF::Vocabulary.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
    idorg = RDF::Vocabulary.new("http://info.identifiers.org/")
    dbp = RDF::Vocabulary.new("http://dbpedia.org/resource/")
    ut = RDF::Vocabulary.new("http://utprot.net/")

    #########################################################
    #   Construct the graph model of RDF for RDF-SIFTS "Enzyme" 
    #########################################################
    print "The transformation of RDF-SIFTS Enzyme "
    RDF::Writer.open("./result/pdb_chain_enzyme.nt") do |writer|
      CSV.foreach('./download/pdb_chain_enzyme.lst', headers:true, col_sep:'	') {|row|
        row0 = row[0].upcase # PDB
        row1 = row[1].upcase # CHAIN
        row2 = row[2].upcase # ACCESSION
        row3 = row[3].upcase # EC_NUMBER

        if /^#/ =~ row0
        else
          pdb_resource = ut.to_s + "pdb/" + row0.to_s + "/auth_asym/" + row1.to_s
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

  def asymConvert
  #########################################################
  #    Metho of RDF-SIFTS asymConvert
  #########################################################
#
#=begin
    #########################################################
    #    Load the undefined Classes into prefix of SPARQL in "RDF.rb".
    #########################################################
    edam = RDF::Vocabulary.new("http://edamontology.org/")
    pdbo = RDF::Vocabulary.new("http://rdf.wwpdb.org/schema/pdbx-v40.owl#")
    pdbr = RDF::Vocabulary.new("http://rdf.wwpdb.org/pdb/")
    up = RDF::Vocabulary.new("http://purl.uniprot.org/core/")
    upr = RDF::Vocabulary.new("http://purl.uniprot.org/uniprot/")
    rdf = RDF::Vocabulary.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
    idorg = RDF::Vocabulary.new("http://info.identifiers.org/")
    dbp = RDF::Vocabulary.new("http://dbpedia.org/resource/")
    ut = RDF::Vocabulary.new("http://utprot.net/")

    #########################################################
    #   Construct the graph model of RDF for RDF-SIFTS "Asym" 
    #########################################################
    print "The transformation of RDF-SIFTS Asym "
    RDF::Writer.open("./result/pdb_chain_labelasym.nt") do |writer|
      CSV.foreach('./data/pdb_chain_labelasym.list', headers:true, col_sep:'	') {|row|
        row0 = row[0].upcase # PDB
        row1 = row[1].upcase # AUTH_ASYM_ID (CHAIN)
        row2 = row[2].upcase # LABEL_ASYM_ID

        if /^#/ =~ row0
        else
          pdb_resource = ut.to_s + "pdb/" + row0.to_s + "/auth_asym/" + row1.to_s
          root_uri = RDF::URI.new(pdb_resource)

          label_asym = pdbr.to_s + row0.to_s + "/struct_asym/" + row2.to_s
          label_asym_uri = RDF::URI.new(label_asym)

          pdb_top = pdbr.to_s + row0.to_s
          pdb_top_uri = RDF::URI.new(pdb_top)

	  property1 = pdbo.to_s + "struct_asym.id"
          property1_uri = RDF::URI.new(property1)

          writer << RDF::Graph.new do |graph|
            bnode1 = RDF::Node.uuid.to_s.insert(0,"genid").delete("-").delete("_:")
	    bnode1 = RDF::Node.new(bnode1)
	    graph.insert([root_uri, rdf.type, edam.data_1008])
            graph.insert([root_uri, pdbo.of_datablock, pdb_top_uri])
	      graph.insert([pdb_top_uri, rdf.type, edam.data_1127])
	    graph.insert([root_uri, property1_uri, label_asym_uri])
	      graph.insert([label_asym_uri, rdf.type, pdbo.struct_asym])
	      graph.insert([label_asym_uri, pdbo.of_datablock, pdb_top_uri])
          end
        end
      }
    end
    print "was completed!\n"
#=end
  end


end



#########################################################
#   The command line options
#########################################################
opts = OptionParser.new
opts.banner = "Usage: rdf-sifts-maker.rb [options]"

opts.separator ""
opts.separator "Specific options:"

# Full download and covert
opts.on("-f", "--full", "Fetch the SIFTS from EBI and convert to the RDF format on all RDF-SIFTS.") do |all|
  run = RDFSIFTS.new
  run.cathGet
  run.cathConvert
  run.enzymeGet
  run.enzymeConvert
  run.goGet
  run.goConvert
  run.interproGet
  run.interproConvert
  run.pubmedGet
  run.pubmedConvert
  run.pfamGet
  run.pfamConvert
  run.scopGet
  run.scopConvert
  run.taxonomyGet
  run.taxonomyConvert
  run.uniprotGet
  run.uniprotConvert
  run.asymConvert
end

# All convert
opts.on("-r", "--run", "Convert all data to RDF format on RDF-SIFTS without download process.") do |all|
  run = RDFSIFTS.new
  run.cathConvert
  run.enzymeConvert
  run.goConvert
  run.interproConvert
  run.pubmedConvert
  run.pfamConvert
  run.scopConvert
  run.taxonomyConvert
  run.uniprotConvert
  run.asymConvert
end

# All download
opts.on("-d", "--download", "Fetch all RDF-SIFTS data from EBI withouth convering process.") do |all|
  run = RDFSIFTS.new
  run.cathGet
  run.enzymeGet
  run.goGet
  run.interproGet
  run.pubmedGet
  run.pfamGet
  run.scopGet
  run.taxonomyGet
  run.uniprotGet
end

# Download and Convert about each file
opts.on("-a", "--asym", "Convert the list of protein chain id link between PDB author asym and PDB lable asym to the RDF-SIFTS Asym.") do |asym|
  run = RDFSIFTS.new
  run.asymConvert
end
opts.on("-c", "--cath", "Fetch the file of SIFTS CATH by EBI and convert to the RDF-SIFTS CATH.") do |cath|
  run = RDFSIFTS.new
  run.cathGet
  run.cathConvert
end
opts.on("-e", "--enzyme", "Fetch the file of SIFTS Enzyme by EBI and convert to the RDF-SIFTS Enzyme.") do |enzyme|
  run = RDFSIFTS.new
  run.enzymeGet
  run.enzymeConvert
end
opts.on("-g", "--go", "Fetch the file of SIFTS GO by EBI and convert to the RDF-SIFTS GO.") do |go|
  run = RDFSIFTS.new
  run.goGet
  run.goConvert
end
opts.on("-i", "--interpro", "Fetch the file of SIFTS InterPro by EBI and convert to the RDF-SIFTS InterPro.") do |interpro|
  run = RDFSIFTS.new
  run.interproGet
  run.interproConvert
end
opts.on("-m", "--pubmed", "Fetch the file of SIFTS PubMed by EBI and convert to the RDF-SIFTS PubMed.") do |pubmed|
  run = RDFSIFTS.new
  run.pubmedGet
  run.pubmedConvert
end
opts.on("-p", "--pfam", "Fetch the file of SIFTS Pfam by EBI and convert to the RDF-SIFTS Pfam.") do |pfam|
  run = RDFSIFTS.new
  run.pfamGet
  run.pfamConvert 
end
opts.on("-s", "--scop", "Fetch the file of SIFTS SCOP by EBI and convert to the RDF-SIFTS SCOP.") do |scop|
  run = RDFSIFTS.new
  run.scopGet
  run.scopConvert
end
opts.on("-t", "--taxonomy", "Fetch the file of SIFTS Taxonomy by EBI and convert to the RDF-SIFTS Taxonomy.") do |taxonomy|
  run = RDFSIFTS.new
  run.taxonomyGet
  run.taxonomyConvert
end
opts.on("-u", "--uniprot", "Fetch the file of SIFTS UniProt by EBI and convert to the RDF-SIFTS UniProt.") do |uniprot|
  run = RDFSIFTS.new
  run.uniprotGet
  run.uniprotConvert
end

# Download only about each file
opts.on("--cath-download", "Fetch the file of SIFTS CATH from EBI.") do |cath1|
  run = RDFSIFTS.new
  run.cathGet
end
opts.on("--enzyme-download", "Fetch the file of SIFTS Enzyme from EBI.") do |enzyme1|
  run = RDFSIFTS.new
  run.enzymeGet
end
opts.on("--go-download", "Fetch the file of SIFTS GO from EBI.") do |go1|
  run = RDFSIFTS.new
  run.goGet
end
opts.on("--interpro-download", "Fetch the file of SIFTS InterPro from EBI.") do |interpro1|
  run = RDFSIFTS.new
  run.interproGet
end
opts.on("--pubmed-download", "Fetch the file of RDF-SIFTS PubMed from EBI.") do |pubmed1|
  run = RDFSIFTS.new
  run.pubmedGet
end
opts.on("--pfam-download", "Fetch the file of SIFTS Pfam from EBI.") do |pfam1|
  run = RDFSIFTS.new
  run.pfamGet
end
opts.on("--scop-download", "Fetch the file of SIFTS SCOP from EBI.") do |scop1|
  run = RDFSIFTS.new
  run.scopGet
end
opts.on("--taxonomy-download", "Fetch the file of SIFTS Taxonomy from EBI.") do |taxonomy1|
  run = RDFSIFTS.new
  run.taxonomyGet
end
opts.on("--uniprot-download", "Fetch the file of SIFTS UniProt from EBI.") do |uniprot1|
  run = RDFSIFTS.new
  run.uniprotGet
end

# Convert about each file
opts.on("--cath-convert", "Convert the file of SIFTS CATH by EBI to the RDF-SIFTS CATH.") do |cath2|
  run = RDFSIFTS.new
  run.cathConvert
end
opts.on("--enzyme-convert", "Convert the file of SIFTS Enzyme by EBI to the RDF-SIFTS Enzyme.") do |enzyme2|
  run = RDFSIFTS.new
  run.enzymeConvert
end
opts.on("--go-convert", "Convert the file of SIFTS GO by EBI to the RDF-SIFTS GO.") do |go2|
  run = RDFSIFTS.new
  run.goConvert
end
opts.on("--interpro-convert", "Convert the file of SIFTS InterPro by EBI to the RDF-SIFTS InterPro.") do |interpro2|
  run = RDFSIFTS.new
  run.interproConvert
end
opts.on("--pubmed-convert", "Convert the file of SIFTS PubMed by EBI to the RDF-SIFTS PubMed.") do |pubmed2|
  run = RDFSIFTS.new
  run.pubmedConvert
end
opts.on("--pfam-convert", "Convert the file of SIFTS Pfam by EBI to the RDF-SIFTS Pfam.") do |pfam2|
  run = RDFSIFTS.new
  run.pfamConvert 
end
opts.on("--scop-convert", "Convert the file of SIFTS SCOP by EBI to the RDF-SIFTS SCOP.") do |scop2|
  run = RDFSIFTS.new
  run.scopConvert
end
opts.on("--taxonomy-convert", "Convert the file of SIFTS Taxonomy by EBI to the RDF-SIFTS Taxonomy.") do |taxonomy2|
  run = RDFSIFTS.new
  run.taxonomyConvert
end
opts.on("--uniprot-convert", "Convert the file of SIFTS UniProt by EBI to the RDF-SIFTS UniProt.") do |uniprot2|
  run = RDFSIFTS.new
  run.uniprotConvert
end



opts.separator ""
opts.separator "Common options:"

opts.on_tail("-h", "--help", "Show this message.") do
  puts opts
  exit
end

opts.parse!(ARGV)    



