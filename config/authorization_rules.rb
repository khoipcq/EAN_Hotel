authorization do
  role :admin do
    has_permission_on :users, :to => [:index, :show, :new, :create, :edit, 
      :update, :destroy, :reset_password, :enable_user, :disable_user, :change_password]
  end
  role :user do
  	has_permission_on :users, :to => [:change_password]
  end
end