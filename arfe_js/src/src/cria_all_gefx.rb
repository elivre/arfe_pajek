# encoding: UTF-8
require 'fileutils'
#require "i18n"

def convert(l)
ln = (l.strip).tr(
"ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž",
"AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNnOOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz"
)
    return ln
end



def cria_gefx(dir_gefx, arq_net)
Encoding.default_internal = Encoding::ISO_8859_1
Encoding.default_external = Encoding::UTF_8

 #-------------------------------------------------
 #  determina nome de municipio, cargo e ano em arq_net
 #------------------------------------------------ 
  nomes=File.basename(arq_net,'.net').split(/-/)
  ue = (nomes[0].gsub('Network_','')).gsub('_',' ')
  cargo_ano = nomes[2].split(/_/)
  cargo = cargo_ano[0]
  ano   = cargo_ano[1]
 #------------------------------------------------

  arq_gefx =  "#{dir_gefx}/#{File.basename(arq_net).gsub('.net','.gefx')}"
  
  fr  = File.open(arq_net,'r')
  fw  = File.open(arq_gefx, 'w')
 #-------------------------------------------------
 #  determina nome de municipio, cargo e ano em arq_net
 #------------------------------------------------ 
  nomes=File.basename(arq_net,'.net').split(/-/)
  ue = (nomes[0].gsub('Network_','')).gsub('_',' ')
  cargo_ano = nomes[2].split(/_/)
  cargo = cargo_ano[0]
  ano   = cargo_ano[1]
 #------------------------------------------------
  

  
  
  
  fw.puts '<?xml version="1.0" encoding="ISO-8859-1"?>'
  fw.puts '<gefx xmlns="http://www.gefx.net/1.2draft" version="1.2" xmlns:viz="http://www.gefx.net/1.2draft/viz" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.gefx.net/1.2draft http://www.gefx.net/1.2draft/gefx.xsd">'
  fw.puts '  <meta lastmodifieddate="2012-05-20">'
  fw.puts '    <creator>Neilor F. Camargo</creator>'
  fw.puts "    <description>\"Eleições: #{ano} - Cargo: #{cargo} - UE: #{ue}\" </description>"
  fw.puts '  </meta>'



  fw.puts '<graph defaultedgetype="undirected" timeformat="double" mode="static">'
#------ ATRIBUTOS DE NODES -----------------
  fw.puts '<attributes class="node" mode="static">'
  fw.puts '<attribute id="nome" title="Nome" type="string">'
  fw.puts '  <default>""</default>'
  fw.puts '</attribute>'
  fw.puts '</attributes>'


  n=0
  status = 'n'
  ic_color = nil
  fr.each_line do |l|
    if l.start_with?('*Vertices')
      status = 'v'
      fw.puts '<nodes>'
    elsif l.start_with?('*Edges')
      status = 'e'
      fw.puts '</nodes>'
      fw.puts '<edges>'
    elsif status == 'v'
        la = l.split(/"/)
        vertex = la[0].strip
        label  = (la[1].strip)
        atrib  = la[2].strip
        at = atrib.split()
        #x = -512 + (at[0].strip).to_f*1024
        #y =  288 - (at[1].strip).to_f*576
        x = (-640 + (at[0].strip).to_f*1280).round(1) 
        y = (348 - (at[1].strip).to_f*697).round(1)        
        sz = (at[2].strip).to_f
        
        if i=at.index('ic') 
          ic_color = at[i+1].strip 
        end
        
=begin        
        puts '--------'
        puts ic_color
        puts '--------'
              
        puts vertex,label,atrib,at,ic_color, at[1] 
=end

        lb = label.split(/[\(|\)]/)
        nome  = lb[0]
        cat   = (lb[1]) ? lb[1].split(' ') : ['','']
        tipo  = (cat[0].slice(0,2) == 'PJ') ? '(PJ)' : "(#{cat[0]})"
        partido = cat[1] 
        sexo  = (lb[2]) ? lb[2].gsub(' - ','') : ''
        
=begin        
        puts "----------------"
        puts lb,nome,tipo,partido,sexo
        puts "----------------"
=end
        
        #fw.puts "<node id=\"#{vertex}\" label=\"#{label}\">"
        fw.puts "<node id=\"#{vertex}\" label=\"#{vertex}\">"
        fw.puts "<viz:size value=\"4\"></viz:size>"
        fw.puts "<viz:position x=\"#{x}\" y=\"#{y}\"></viz:position>"
#=begin
        if ic_color == 'Blue'
           fw.puts "<viz:color r=\"0\" g=\"0\" b=\"255\"></viz:color>"
        elsif ic_color == 'Red'
           fw.puts "<viz:color r=\"255\" g=\"0\" b=\"0\"></viz:color>" 
        elsif ic_color == 'Green'
           fw.puts "<viz:color r=\"0\" g=\"255\" b=\"0\"></viz:color>" 
        else
           fw.puts "<viz:color r=\"155\" g=\"155\" b=\"155\"></viz:color>" 
        end       
#=end  

#=begin 
        sexof = (sexo != '') ? "(#{sexo})": ''    
        fw.puts "<attvalues>"
        fw.puts     "<attvalue for=\"nome\" value=\"#{nome}#{sexof} #{tipo} #{partido}\"/>"
        fw.puts "</attvalues>"
#=end
       
        fw.puts "</node>"
    elsif status == 'e'
        le = l.split()
        source = le[0].strip
        target = le[1].strip
        weight = ((le[2].strip).to_i).to_s
        n=n+1
        fw.puts "<edge id=\"#{n}\" source=\"#{source}\" target=\"#{target}\" weight=\"#{weight}\"/>"
        
  
    end 
  end
  fw.puts '</edges>'
  fw.puts '</graph>'
  fw.puts '</gefx>'
  #fr.close()
  #fw.close()
end

def gera_all_gefx(dir_net, dir_gefx)
  Dir.glob(dir_net+"/*.net") do |arq_net|
    cria_gefx(dir_gefx, arq_net)
  end
end



#cria_gefx("arfe","RedesCargoUE_2012/network-copia/Network_ABADIA_DE_GOIAS-93360-Prefeito_2012.net")

#cria_gefx("../RedesCargoUE_2012/network-copia/Network_SAO_PAULO-71072-VEREADOR_2012.net","net1.gefx")

gera_all_gefx("../RedesCargoUE_2012/network_draw", "../RedesCargoUE_2012/draw-gefx")


