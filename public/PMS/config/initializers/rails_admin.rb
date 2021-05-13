
RailsAdmin.config do |config|
require Rails.root.join('lib', 'rails_admin', 'email_action.rb')
require Rails.root.join('lib', 'rails_admin', 'org_action.rb')

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :admin
   end
  config.current_user_method(&:current_admin)

  ## == CancanCan ==
  config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    email_action do
    visible do
        bindings[:abstract_model].model.to_s == "User"
      end
    end 
    org_action do
    visible do
        bindings[:abstract_model].model.to_s == "Organization"
      end
    end

      # Make it visible only for specific model.
      # You can remove this if you don’t need.
      # visible do
      #   bindings[:abstract_model].model.to_s == `MediaTarget`
      # end
    # bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
