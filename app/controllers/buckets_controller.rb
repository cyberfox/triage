class BucketsController < ApplicationController
  # GET /buckets
  # GET /buckets.xml
  def index
    @buckets = Bucket.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @buckets }
    end
  end

  # GET /buckets/1
  # GET /buckets/1.xml
  def show
    @bucket = Bucket.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bucket }
    end
  end

  # GET /buckets/new
  # GET /buckets/new.xml
  def new
    @bucket = Bucket.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bucket }
    end
  end

  # GET /buckets/1/edit
  def edit
    @bucket = Bucket.find(params[:id])
  end

  # POST /buckets
  # POST /buckets.xml
  def create
    @bucket = Bucket.new(params[:bucket])

    respond_to do |format|
      if @bucket.save
        flash[:notice] = 'Bucket was successfully created.'
        format.html { redirect_to(@bucket) }
        format.xml  { render :xml => @bucket, :status => :created, :location => @bucket }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bucket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /buckets/1
  # PUT /buckets/1.xml
  def update
    @bucket = Bucket.find(params[:id])

    respond_to do |format|
      if @bucket.update_attributes(params[:bucket])
        flash[:notice] = 'Bucket was successfully updated.'
        format.html { redirect_to(@bucket) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bucket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /buckets/1
  # DELETE /buckets/1.xml
  def destroy
    @bucket = Bucket.find(params[:id])
    @bucket.destroy

    respond_to do |format|
      format.html { redirect_to(buckets_url) }
      format.xml  { head :ok }
    end
  end
end
