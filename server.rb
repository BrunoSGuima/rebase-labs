
require 'sinatra'
require 'rack/handler/puma'
require 'json'
require_relative 'exam'

set :public_folder, 'public'


get '/tests' do
  content_type :json
  response = Exam.all.to_json
end

get '/exams' do
  content_type :json
  exams = Exam.all.map { |exam| OpenStruct.new(exam) }.group_by(&:exame_token)

  results = exams.map do |token, exam_results|
    exam_info = exam_results.first
    {
      'result_token' => token,
      'result_date' => exam_info.exame_data,
      'cpf' => exam_info.cpf,
      'name' => exam_info.paciente_nome,
      'email' => exam_info.paciente_email,
      'birthday' => exam_info.paciente_data_nascimento,
      'doctor' => {
        'crm' => exam_info.medico_crm,
        'crm_state' => exam_info.medico_crm_estado,
        'name' => exam_info.medico_nome
      },
      'tests' => exam_results.map do |exam|
        {
          'type' => exam.exame_tipo,
          'limits' => exam.exame_limites,
          'result' => exam.exame_resultado
        }
      end
    }
  end

  results.to_json
end

get '/' do
  erb :index
end

get '/exams/:token/data' do
  token = params['token']
  @result = Exam.find_by_token(token)

  if @result
    erb :exam_details
  else
    status 404
    { error: 'Nenhum exame encontrado' }.to_json
  end
end


get '/exams/:token' do
  content_type :json
  token = params['token']
  exams_hash = Exam.find_by_token(token)

  if exams_hash[token]&.any?
    exams = exams_hash[token]
    patient_info = exams.first.slice('cpf', 'paciente_nome', 'paciente_email', 'paciente_data_nascimento', 'paciente_endereco', 'paciente_cidade', 'paciente_estado')
    doctor_info = exams.first.slice('medico_crm', 'medico_crm_estado', 'medico_nome', 'medico_email')

    exame_data = exams.first['exame_data']

    result = {
      "Paciente" => patient_info,
      "Médico" => doctor_info,
      "Exames" => {
        "Exame Token" => token,
        "Data do Exame" => exame_data,
        "Resultados" => exams.map.with_index { |exam, index| "#{index + 1}. Tipo: #{exam['exame_tipo']}, Limites: #{exam['exame_limites']}, Resultado: #{exam['exame_resultado']}" }
      }
    }

    result.to_json
  else
    status 404
    { error: 'Nenhum exame encontrado' }.to_json
  end
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)