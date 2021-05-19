module RailsAdmin
  module Config
    module Actions
      class UpdateAction < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :collection do
          true
        end

        register_instance_option :http_methods do
          [:post, :get]
        end

        register_instance_option :controller do
          proc do
            @users = list_entries(@model_config)
            if request.params['bulk_step'].blank?            # Selecting a category
              if @users.blank?
                flash[:error] = 'No users selected to update'  #if no users are selected
                redirect_to index_path
              else
                render @action.template_name
              end
            else
                array = []                                    #stroring bulk ids in array 
                array = params["bulk_ids"]
                array.each do |id|
              @user = User.find(id)
              @user.update_column(:country, params["country"])         #updating require element in selected ids
              end 
              flash[:success] = 'updated'
              redirect_to index_path
            end
         end
          
        end
        register_instance_option :bulkable? do
          true
        end
      end
    end
  end
end