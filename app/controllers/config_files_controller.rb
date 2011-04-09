class ConfigFilesController < ApplicationController

  # GET /config_files
  # GET /config_files.xml
  def index
    @config_files = ConfigFile.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @config_files }
    end
  end

  # GET /config_files/1
  # GET /config_files/1.xml
  def show
    @config_file = ConfigFile.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @config_file }
    end
  end

  # GET /config_files/new
  # GET /config_files/new.xml
  def new
    @config_file = ConfigFile.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @config_file }
    end
  end

  # GET /config_files/1/edit
  def edit
    @config_file = ConfigFile.get(params[:id])
  end

  # POST /config_files
  # POST /config_files.xml
  def create
    @config_file = ConfigFile.new(params[:config_file])

    respond_to do |format|
      if @config_file.save
        format.html { redirect_to(@config_file, :notice => 'Config file was successfully created.') }
        format.xml  { render :xml => @config_file, :status => :created, :location => @config_file }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @config_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /config_files/1
  # PUT /config_files/1.xml
  def update
    @config_file = ConfigFile.get(params[:id])

    respond_to do |format|
      if @config_file.update(params[:config_file])
        format.html { redirect_to(config_files_path, :notice => 'Config file was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @config_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /config_files/1
  # DELETE /config_files/1.xml
  def destroy
    @config_file = ConfigFile.get(params[:id])
    @config_file.destroy

    respond_to do |format|
      format.html { redirect_to(config_files_url) }
      format.xml  { head :ok }
    end
  end

  def generate
    # get or create config file
    @config_file = ConfigFile.get(params[:id])
    # if need update
    if !@config_file.current?
      @config_file.generate
    end
    redirect_to config_files_path
  end

end
