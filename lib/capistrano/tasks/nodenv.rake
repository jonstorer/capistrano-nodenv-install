namespace :nodenv do
  task :ensure do
    on roles(fetch(:nodenv_install_roles)) do
      if fetch(:nodenv_node).nil?
        error "nodenv: nodenv_node is not set"
        exit 1
      end

      SSHKit.config.command_map[:nodenv] = "#{fetch(:nodenv_install_path)}/bin/nodenv"
      execute :nodenv, :install, '-s', fetch(:nodenv_node)
    end
  end
end

Capistrano::DSL.stages.each do |stage|
  after stage, 'nodenv:ensure'
end

namespace :load do
  task :defaults do
    paths = { :system => '/usr/local/nodenv', :user => '$HOME/.nodenv' }

    set :nodenv_install_type,  fetch(:nodenv_install_type, :user)
    set :nodenv_install_roles, fetch(:nodenv_install_roles, :all)
    set :nodenv_install_path,  -> { fetch(:nodenv_install_custom_path, paths[fetch(:nodenv_install_type)]) }
  end
end
