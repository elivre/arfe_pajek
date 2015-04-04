# encoding: ISO-8859-1


def ajusta_texto(dir_fonte, dir_net, dir_rel, dir_copia, arq_rel)
  frn = dir_fonte+'/'+dir_rel+'/'+arq_rel
  fwn = dir_fonte+'/'+dir_copia+'/'+arq_rel     
  
  puts frn+' => '+fwn
  fr  = File.open(frn,'r')
  fw  = File.open(fwn, 'w')
  n=0
  fr.each_line do |l|
    n=n+1
    if n>13
      if  not l.start_with?(' Working...')
        fw.puts l
    end 
  end
  #fr.close()
  #fw.close()
end

end

def create_arq_macro(arq_macro, arq_rede, arq_rel)
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


def gera_relatorio(dir_fonte, dir_net, dir_rel, arq_net)
  #Dir.chdir(dir_fonte)
  
  arq_rede = dir_fonte+'/'+dir_net+'/'+arq_net
  arq_rede = arq_rede.encode('iso-8859-1')
 
  
  arq_rel = arq_net.partition('.')[0]+'.txt'
  arq_rel_full = dir_fonte+'/'+dir_rel+'/'+arq_rel
  arq_macro = '/home/neilorca/PAJEK_REL.log'

  #puts 'create_arq_macro(arq_macro: #{arq_macro}, arq_rede: #{arq_rede}, arq_rel: #{arq_rel})'
  create_arq_macro(arq_macro, arq_rede, arq_rel_full)

  pajek_exe = '/home/neilorca/.wine/drive_c/programs/Pajek.exe'
  run = "wine #{pajek_exe} /home/neilorca/PAJEK_REL.log"
  puts run
  system(run)
  
  #ajusta_texo(dir_net, dir_copia, arq_rel) 
  ajusta_texto(dir_fonte, dir_net, dir_rel, 'report', arq_rel)
end

def gera_all_relatorios(dir_fonte, dir_net, dir_rel)
  #Dir.chdir(dir_fonte)
  Dir.glob("*.net") do |arq_net|
    puts 'gera_relatorio(dir_fonte: #{dir_fonte} dir_net: #{dir_net} arq_net: #{arq_net})'
    #gera_relatorio(dir_fonte, dir_net, dir_rel, arq_net)
  end
end

gera_all_relatorios(
'RedesCargoUE_2012',
'network-copia',
'report'
)

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

