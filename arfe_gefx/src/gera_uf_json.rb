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


  #-- busca todos as uf
  ufs = conn.exec(
  "select candidato_sigla_uf
  from e#{ano}.candidatos
  group by  candidato_sigla_uf 
  order by  CANDIDATO_sigla_uf"
  )
  ufs_size = ufs.ntuples()

  arq_xml = File.open("../resource/json/Uf#{ano}.json", 'w')  
  arq_xml.puts '{"json":['
  ufs.each_row do |uf|
   arq_xml.puts "\"#{sigla_uf}\","
  end
  arq_xml.puts ']}'
  
end

gera_ue_xml("2012")

