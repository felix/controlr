class ServiceInstancesController < ApplicationController
  # GET /service_instances
  # GET /service_instances.xml
  def index
    @service_instances = ServiceInstance.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @service_instances }
    end
  end

  # GET /service_instances/1
  # GET /service_instances/1.xml
  def show
    @service_instance = ServiceInstance.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @service_instance }
    end
  end

  # GET /service_instances/new
  # GET /service_instances/new.xml
  def new
    @service_instance = ServiceInstance.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @service_instance }
    end
  end

  # GET /service_instances/1/edit
  def edit
    @service_instance = ServiceInstance.get(params[:id])
  end

  # POST /service_instances
  # POST /service_instances.xml
  def create
    @service_instance = ServiceInstance.new(params[:service_instance])

    respond_to do |format|
      if @service_instance.save
        format.html { redirect_to(@service_instance, :notice => 'Service instance was successfully created.') }
        format.xml  { render :xml => @service_instance, :status => :created, :location => @service_instance }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @service_instance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /service_instances/1
  # PUT /service_instances/1.xml
  def update
    @service_instance = ServiceInstance.get(params[:id])

    respond_to do |format|
      if @service_instance.update(params[:service_instance])
        format.html { redirect_to(@service_instance, :notice => 'Service instance was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service_instance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /service_instances/1
  # DELETE /service_instances/1.xml
  def destroy
    @service_instance = ServiceInstance.get(params[:id])
    @service_instance.destroy

    respond_to do |format|
      format.html { redirect_to(service_instances_url) }
      format.xml  { head :ok }
    end
  end
end
