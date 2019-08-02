namespace :dev do

  DEFAULT_PASSWORD = 123456

  desc 'Apaga, cria, migra e popula banco de dados'
  task setup: :environment do

    if Rails.env.development?
      show_sppiner("Apagando BD...") {%x{rails db:drop}}

      show_sppiner("Criando BD...") {%x{rails db:create}}

      show_sppiner("Migrando BD...") {%x{rails db:migrate}}

      show_sppiner("Cadastrando o Administrador padrão...") {%x{rails dev:add_default_admin}}

      show_sppiner("Cadastrando administradores extras...") {%x{rails dev:add_extras_admins}}

      show_sppiner("Cadastrando o Usuário padrão...") {%x{rails dev:add_default_user}}

      show_sppiner("Cadastrando Assuntos padrões...") {%x{rails dev:add_subjects}}

      show_sppiner("Cadastrando perguntas e respostas...") {%x{rails dev:add_answers_and_questions}}

    else
      puts "Você não está em ambiente de desenvolvimento"
    end
  end

  desc 'Adiciona o administrador padrão'
  task add_default_admin: :environment do
    Admin.create!(
        email: 'admin@admin.com',
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc 'Adiciona o administrador padrão'
  task add_default_user: :environment do
    User.create!(
        email: 'user@user.com',
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc 'Adiciona administradores extras'
  task add_extras_admins: :environment do
    10.times do |i|
      Admin.create!(
          email: Faker::Internet.email,
          password: DEFAULT_PASSWORD,
          password_confirmation: DEFAULT_PASSWORD
      )
    end
  end

  desc 'Adiciona assuntos padrões'
  task add_subjects: :environment do
    file_name = 'subjects.txt'
    file_path = File.join(Rails.root, 'lib', 'tmp', file_name)

    File.open(file_path, 'r').each do |line|
      Subject.create!(description: line.strip)
    end
  end

  desc 'Adiciona perguntas e respostas'
  task add_answers_and_questions: :environment do
    Subject.all.each do |subject|
      # Criar 3 a 5 questoes por cada assunto
      rand(2..3).times do |i|
        Question.create!(
            description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
            subject: subject
        )
      end
    end
  end

  private

  def show_sppiner(msg_start, msg_end = "Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}...")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
