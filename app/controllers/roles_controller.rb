class RolesController < ApplicationController
  authorize_resource

  def report
    @roles = Role.all(:name.not => 'super')
    if request.post?
      @roles.each do |role|
        role.update(:permissions => params[:permissions][role.name])
      end
      flash[:notice] = 'Roles successfully updated'
    end
  end
end
