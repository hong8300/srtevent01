ActiveAdmin.register Event do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :description, :rec_starttime, :status, :output_filename, :passphrase, :server_url, :server_port, :sdata1, :sdata2, :idata1, :idata2
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description, :rec_starttime, :status, :output_filename, :passphrase, :server_url, :server_port, :sdata1, :sdata2, :idata1, :idata2]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  permit_params :name,:description,:rec_starttime,:status,:output_filename,:passphrase,:server_url,:server_port,:sdata1, :sdata2,:idata1,:idata2
end
