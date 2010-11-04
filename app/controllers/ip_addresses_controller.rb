class IpAddressesController < ApplicationController
  # GET /ip_addresses
  # GET /ip_addresses.xml
  def index
    @ip_addresses = IpAddress.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ip_addresses }
    end
  end

  # GET /ip_addresses/1
  # GET /ip_addresses/1.xml
  def show
    @ip_address = IpAddress.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ip_address }
    end
  end

  # GET /ip_addresses/new
  # GET /ip_addresses/new.xml
  def new
    @ip_address = IpAddress.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ip_address }
    end
  end

  # GET /ip_addresses/1/edit
  def edit
    @ip_address = IpAddress.get(params[:id])
  end

  # POST /ip_addresses
  # POST /ip_addresses.xml
  def create
    @ip_address = IpAddress.new(params[:ip_address])

    respond_to do |format|
      if @ip_address.save
        format.html { redirect_to(@ip_address, :notice => 'Ip address was successfully created.') }
        format.xml  { render :xml => @ip_address, :status => :created, :location => @ip_address }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ip_address.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ip_addresses/1
  # PUT /ip_addresses/1.xml
  def update
    @ip_address = IpAddress.get(params[:id])

    respond_to do |format|
      if @ip_address.update(params[:ip_address])
        format.html { redirect_to(@ip_address, :notice => 'Ip address was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ip_address.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ip_addresses/1
  # DELETE /ip_addresses/1.xml
  def destroy
    @ip_address = IpAddress.get(params[:id])
    @ip_address.destroy

    respond_to do |format|
      format.html { redirect_to(ip_addresses_url) }
      format.xml  { head :ok }
    end
  end
end
