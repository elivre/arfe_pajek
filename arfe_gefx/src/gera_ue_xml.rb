# encoding: ISO-8859-1
require 'pg'
require 'fileutils'

def convert_char(nome_ue_fn)
  nome_ue_fn = (nome_ue.gsub(/ /,'_')).upcase
  nome_ue_fn = nome_ue_fn.gsub(/ÁÀÂÃ/,'A')
  nome_ue_fn = nome_ue_fn.gsub(/ÍÌĨÎ/,'I')
  nome_ue_fn = nome_ue_fn.gsub(/ÓÒÔÕ/,'O')
  nome_ue_fn = nome_ue_fn.gsub(/ÚÙÛŨ/,'U')
  nome_ue_fn = nome_ue_fn.gsub(/ÉÊÈ/,'E')
  nome_ue_fn = nome_ue_fn.gsub(/Ç/,'C')
  nome_ue_fn = nome_ue_fn.gsub(/'/,'')
  nome_ue_fn = nome_ue_fn.gsub(/"/,'')
  return nome_ue_fn

end

def gera_ue_xml(ano)

  conn = PG::Connection.new(:hostaddr => '177.101.20.86', :dbname => 
  'gete_tse', :user=>'neilor', :password=> 'n1f2c3N!') 


  #-- busca todos os ues
  ues = conn.exec(
  "select ano_eleicao, candidato_sigla_uf, CANDIDATO_sigla_ue, candidato_nome_ue 
  from e#{ano}.candidatos
  group by ano_eleicao, candidato_sigla_uf, CANDIDATO_sigla_ue, candidato_nome_ue 
  order by  CANDIDATO_sigla_ue"
  )


  arq_xml = File.open("../xml/e#{ano}_ue.xml", 'w')  
  arq_xml.puts '<?xml version="1.0" encoding="ISO-8859-1"?>'
  arq_xml.puts "<ues>"
  ues.each_row do |ue|
   ano      = ue[0]
   sigla_uf = ue[1]
   sigla_ue = ue[2]
   nome_ue  = ((ue[3].strip).encode('utf-8'))
   arq_xml.puts "<ue sigla_uf=\"#{sigla_uf}\" id=\"#{sigla_ue}\">#{nome_ue}</ue>"
  end
  arq_xml.puts "</ues>"
  
end

gera_ue_xml("2012")

