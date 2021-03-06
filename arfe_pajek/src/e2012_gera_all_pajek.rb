# encoding: ISO-8859-1
require 'iconv'
require 'fileutils'

def ajusta_arq(dir_net_grafo, arq_net_grafo)
  frn = arq_net_grafo
  fwn = "#{dir_net_grafo}/#{File.basename(arq_net_grafo,'.net')+'.net2'}"

  puts frn+' => '+fwn
  fr  = File.open(frn,'r')
  fw  = File.open(fwn, 'w')
  n=0
  fr.each_line do |l|
        fw.puts convert_linha(l)
  end
 #File.delete(frn)
end

def ajusta_arq_report(dir_report, arq_rel)
  frn = arq_rel
  fwn = "#{dir_report}/#{File.basename(arq_rel,'.tx')+'.txt'}"

  puts frn+' => '+fwn
  fr  = File.open(frn,'r')
  fw  = File.open(fwn, 'w')
  n=0
  fr.each_line do |l|
    n=n+1
    l = l.gsub("/home/neilorca/TSE/arfe2012/RedesCargoUE_2012/network/",'')
    if n>13
      if  not l.start_with?(' Working...')
        fw.puts convert_linha(l)
    end
  end
 end
 File.delete(frn)
end

def create_macro_rel(arq_macro, arq_rede, arq_rel)
  arq = arq_rede
  macro = [
  "NETBEGIN 1\nPERBEGIN 1\nCLSBEGIN 1\nHIEBEGIN 1\nVECBEGIN 1\n\n",
  "Msg Reading Network   ---    #{arq_rede}\n",
  "N 1 RDN \"#{arq_rede}\"\n",
  "Msg 1. #{arq}\n",
  "N 1 INFONET 1 99999 1\n",
  "Msg Triadic Census 1. #{arq}\n",
  "N 1 TRIADS 1 2\n",
  "Msg 2. Expected Triadic Census of N1\n",
  "V 2 INFOVEC2 2 99 1\n",
  "Msg 1. #{arq}\n",
  "N 1 NETINDICES1 1\n",
  "Msg All degree centrality of 1.\n",
  "V 3 DEGV 1 [2]\n",
  "Msg 3. All Degree of N1\n",
  "V 3 INFOVEC1 3 1  99999 1 #51\n",
  "V 4 LINESUM 1 [2]\n",
  "Msg 4. Weighted All Degree of N1\n",
  "V 4 INFOVEC1 4 1  99999 1 #4\n",
  "Msg All closeness centrality of 1.\n",
  "V 5 CLOSE 1 [2]\n",
  "Msg 5. All closeness centrality in N1\n",
  "V 5 INFOVEC1 5 1  0 1 #4\n",
  "Msg Betweenness centrality of 1.\n",
  "V 6 BETWEEN 1\n",
  "Msg 6. Betweenness centrality in N1\n",
  "V 6 INFOVEC1 6 1  99999 1 #4\n",
  "Msg 6. Betweenness centrality in N1\n",
  "V 6 INFOVEC1 6 1  999 1 #4\n",
  "Msg All degree centrality of 1.\n",
  "C 1 DEGC 1 [2]\n",
  "Msg 1. All Degree Partition of N1\n",
  "C 1 INFOCLU1 1 1 999 1 1\n",
  "Msg Weak Components\n",
  "C 2 COMP 1 [2] [1]\n",
  "Msg Strong Components\n",
  "C 3 COMP 1 [1] [1]\n",
  "SAVEREPORT \"#{arq_rel}\"\n",
  "EXIT\n"
  ]

  File.open(arq_macro, 'w' ) do |fn|
      macro.each do |l|
	     fn.puts l
	     puts l
	    end
	    fn.close()
  end
end

def gera_relatorio(dir_report, arq_net)
 
  arq_rel = "#{dir_report}/#{File.basename(arq_net,'.net')+'.tx'}"
  arq_macro = "#{dir_report}/logs/#{File.basename(arq_net,'.net')+'.log'}"
  create_macro_rel(arq_macro, arq_net, arq_rel)
  pajek_exe = '/home/neilorca/.wine/drive_c/programs/Pajek.exe'
  #pajek_exe = dir_net+'/Pajek.exe'
  run = "wine #{pajek_exe} #{arq_macro}"
  puts run
  system(run)

  #ajusta_texo(dir_net, dir_copia, arq_rel)
  ajusta_arq_report(dir_report, arq_rel)
end

def create_macro_grafo(arq_macro, arq_rede, arq_grafo)
  #o arquivo pajek.ini deve estar no mesmo diretorio dos .net
  arq = arq_rede
  macro =
  [
    "LOADINI #{File.dirname(arq_rede)}/pajek3.ini\n",
 	  "NETBEGIN 1\nCLUBEGIN 1\nPERBEGIN 1\nCLSBEGIN 1\nHIEBEGIN 1\nVECBEGIN 1\nNETPARAM 1\nCLUPARAM 1\n\n",
	  "N 1 RDN \"#{arq}\"\n",
	  "DRAWWINDOW ON\n",
	  "E 1 DRAW 0 0 0 0 0\nE 1 KAMADACOMP\n",
  # "E 1 NORMLAYOUT1\n",
	  "E 1 JPEG 0 0 0 0 0 \"#{arq_grafo}\" 100 0\n",
	# "E 1 BITMAP 0 0 0 0 0 \"#{arq_grafo}\" 100 0\n",	  
    "N 1 WN \"#{arq}\"\n",
  #  "N 1 DN\nSAVEINI #{File.dirname(arq_rede)}/pajek3.ini\n",
    "EXIT\n"
  ]
  File.open(arq_macro, 'w' ) do |fn|
     macro.each do |l|
	     fn.puts l
	     puts l
	   end
	  fn.close()
  end
end

def gera_grafo(dir_net_grafo, arq_net_grafo)
  arq_grafo = "#{dir_net_grafo}/#{File.basename(arq_net_grafo,'.net')+'.jpg'}"
  arq_macro = "#{dir_net_grafo}/logs/#{File.basename(arq_net_grafo,'.net')+'-draw.log'}"

  create_macro_grafo(arq_macro, arq_net_grafo, arq_grafo)

  pajek_exe = '/home/neilorca/.wine/drive_c/programs/Pajek.exe'
  #pajek_exe = dir_net+'/Pajek.exe'
  run = "wine #{pajek_exe} #{arq_macro}"
  puts run
  system(run)
  #ajusta_arq(dir_net_grafo, arq_net_grafo)
end



def gera_all_relatorios(dir_net_copia,dir_report,dir_draw)
  Dir.chdir("#{dir_net_copia}")
  Dir.glob("*.net") do |arq_net|
    arq_net = arq_net.force_encoding('iso-8859-1')
    gera_relatorio(dir_report, "#{dir_net_copia}/#{arq_net}")
  end
end


def gera_all_grafos(dir_net_copia,dir_report,dir_draw)
  Dir.chdir("#{dir_net_copia}")
  FileUtils.cp_r "#{dir_net_copia}/." ,"#{dir_draw}"
  Dir.glob("*.net") do |arq_net|
    arq_net = arq_net.force_encoding('iso-8859-1')
    arq_net_grafo = "#{dir_draw}/#{arq_net}"
    arq_net_grafo = arq_net_grafo.force_encoding('iso-8859-1')
    gera_grafo(dir_draw, arq_net_grafo)
  end
end

def convert_linha(linha)
    fn2 = linha.force_encoding('ISO-8859-1')
    fn4 = fn2.gsub(/Á|á|À|à|Â|â|Ã|ã|Ä|ä/,'A')
    fn5 = fn4.gsub(/Í|í|Ì|ì|Ĩ|ĩ|Î|î|Ï|ï/,'I')
    fn6 = fn5.gsub(/Ó|ó|Ò|ò|Ô|ô|Õ|õ|Ö|ö/,'O')
    fn7 = fn6.gsub(/Ú|ú|Ù|ù|Û|û|Ũ|ũ|Ü|ü/,'U')
    fn8 = fn7.gsub(/É|é|Ê|ê|È|è|Ë|ë/,'E')
    fn9 = fn8.gsub(/Ç|ç/,'C')
    fn10 = fn9.gsub(/'/,'_')
    fn11 = fn10#.force_encoding('UTF-8')
    return fn11
end

def convert_arq(arq_net_full, arq_copia_full)
  fr  = File.open(arq_net_full,'r')
  fw  = File.open(arq_copia_full, 'w')
  n=0
  fr.each_line do |l|
        fw.puts convert_linha(l)
  end
 #File.delete(frn)
end

def convert_all(dir_net, dir_net_copia)
  Dir.chdir(dir_net)
  Dir.glob("*.net") do |arq_net|
     convert_arq("#{dir_net}/#{arq_net}","#{dir_net_copia}/#{arq_net}") 
  end 
end

=begin
convert_arq("/home/neilorca/TSE/arfe2012/RedesCargoUE_2012/network-original/Network_ABADIANIA-92010-Prefeito_2012.net","/home/neilorca/TSE/arfe2012/Network_ABADIANIA-92010-Prefeito_2012.net") 
=end

def inicialize(dir_net_copia,dir_report,dir_draw,dir_net)
  Dir.mkdir(dir_net_copia)
  Dir.mkdir(dir_report)
  Dir.mkdir("#{dir_report}/logs")
  Dir.mkdir(dir_draw)
  Dir.mkdir("#{dir_draw}/logs")
  FileUtils.cp("/home/neilorca/TSE/arfe2012/resources/pajek3.ini","#{dir_draw}/pajek3.ini")
  FileUtils.cp("/home/neilorca/TSE/arfe2012/resources/pajek.ini","#{dir_draw}/pajek.ini")
  convert_all(dir_net,dir_net_copia)
end

def e2012_gera_all_pajek()
  dir_net_copia = "/home/neilorca/TSE/arfe2012/RedesCargoUE_2012/network"
  dir_report    = "/home/neilorca/TSE/arfe2012/RedesCargoUE_2012/report"
  dir_draw      = "/home/neilorca/TSE/arfe2012/RedesCargoUE_2012/draw"
  dir_net       = "/home/neilorca/TSE/arfe2012/network-2012-original"
  inicialize(dir_net_copia,dir_report,dir_draw,dir_net)
  gera_all_relatorios(dir_net_copia,dir_report,dir_draw)
  gera_all_grafos(dir_net_copia,dir_report,dir_draw)
end

e2012_gera_all_pajek()

#ruby e2012_gera_all_pajek.rb &> log_e2012_gera_all_pajek &
# inicio 17h43

#puts convert_nome('JOSÈ')


=begin
#gera_relatorio(dir_fonte, dir_net, dir_rel, arq_net)
gera_relatorio(
'RedesCargoUE_2012',
'network-copia',
'report-original',
'Network_JURU-20613-VEREADOR_2012.net'
)
=end

#create_arq_macro('PAJEK_REL.log', 'home/neilorca/TSE/e2012/RedesCargoUE_2012/network/Network_ABADIA_DE_GOIAS-93360-PREFEITO_2012.net')
