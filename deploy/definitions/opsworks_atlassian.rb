define :opsworks_atlassian do
  deploy = params[:deploy_data]
  application = params[:app]

  ssl_web_app do
    application application
    deploy deploy
  end
end
