require 'pg'

class Exam
  def self.all
    db = PG.connect(host: 'db', user: 'myuser', password: 'password')

    result = db.exec('SELECT pacientes.cpf AS cpf, pacientes.nome AS paciente_nome, pacientes.email AS 
      paciente_email, pacientes.data_nascimento AS paciente_data_nascimento, pacientes.endereco AS 
      paciente_endereco, pacientes.cidade AS paciente_cidade, pacientes.estado AS paciente_estado, 
      medicos.crm AS medico_crm, medicos.estado_crm AS medico_crm_estado, medicos.nome AS medico_nome, medicos.email AS 
      medico_email, exames.token AS exame_token, exames.data AS exame_data, exames.tipo AS exame_tipo, exames.limites AS exame_limites, 
      exames.resultado AS exame_resultado FROM pacientes JOIN exames ON 
      exames.paciente_id = pacientes.id JOIN medicos ON medicos.id = exames.medico_id').to_a
  end

  def self.find_by_token(token)
    db = PG.connect(host: 'db', user: 'myuser', password: 'password')
  
    result = db.exec_params(
      'SELECT pacientes.cpf AS cpf, pacientes.nome AS paciente_nome, pacientes.email AS 
      paciente_email, pacientes.data_nascimento AS paciente_data_nascimento, pacientes.endereco AS 
      paciente_endereco, pacientes.cidade AS paciente_cidade, pacientes.estado AS paciente_estado, 
      medicos.crm AS medico_crm, medicos.estado_crm AS medico_crm_estado, medicos.nome AS medico_nome, medicos.email AS 
      medico_email, exames.token AS exame_token, exames.data AS exame_data, exames.tipo AS exame_tipo, exames.limites AS exame_limites, 
      exames.resultado AS exame_resultado FROM pacientes JOIN exames ON 
      exames.paciente_id = pacientes.id JOIN medicos ON medicos.id = exames.medico_id WHERE exames.token = $1', [token]).to_a
  
    result.group_by { |exam| exam["exame_token"] }
  end
  

  def self.find_all_by_token(token)
    result = $conn_postgres.exec_params('SELECT * FROM exames WHERE token = $1', [token])
    result.map do |row|
      exam = self.new
      exam.from_hash(row)
      exam
    end
  end

end