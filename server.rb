require 'sinatra'
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
  content_type :html
  File.open('views/index.html')
end

get '/exams/:token' do
  content_type :json
  token = params['token']
  exams = Exam.find_all_by_token(token)

  if exams.empty?
    {}.to_json
  else
    exam_results = exams.map { |exam| OpenStruct.new(exam) }
    exam_info = exam_results.first
    {
      'result_token' => token,
      'result_date' => exam_info.exame_data,
      'tests' => exam_results.map do |exam|
        {
          'type' => exam.exame_tipo,
          'limits' => exam.exame_limites,
          'result' => exam.exame_resultado
        }
      end
    }.to_json
  end
end

get '/exams-details/:token' do
  # Faz a requisição para a API buscando os dados dos exames pelo token
  response = HTTParty.get("http://localhost:3000/exams/#{params[:token]}")
  data = JSON.parse(response.body)

  # Renderiza a página exam_details.erb com os dados dos exames
  erb :exam_details, locals: { data: data }
end



Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)