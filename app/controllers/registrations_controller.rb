class RegistrationsController < Devise::RegistrationsController

  private

    def sign_up_params
      resource_params
    end

    def resource_params
      params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
    end

end
