namespace :dev do

  DEFAULT_PASSWORD = 123123

  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Drop database") { %x(rails db:drop) }
      show_spinner("Create database") { %x(rails db:create) }
      show_spinner("Migrate database") { %x(rails db:migrate) }
      show_spinner("Cadastrando administrador padrão") { %x(rails dev:add_default_admin) }
      show_spinner("Cadastrando usuário padrão") { %x(rails dev:add_default_user) }
    else
      puts "Você não está no ambiente de desenvolvimento"
    end
  end

  desc "Adiciona o administrador padrão"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona o usuário padrão"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  private

  def show_spinner(msg_start)
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success('(successful)')
  end

end

