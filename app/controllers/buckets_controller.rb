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
    project = current_user.projects.first
    @milestones = project.milestones
    @states = ["-do not change"] + project.states

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bucket }
    end
  end

  # GET /buckets/1/edit
  def edit
    @bucket = Bucket.find(params[:id])
    project = current_user.projects.first
    @milestones = project.milestones
    @states = ["-do not change"] + project.states
  end

  # POST /buckets
  # POST /buckets.xml
  def create
    @bucket = current_user.buckets.new(params[:bucket])

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

    modified = params[:bucket]
    modified[:state] = params[:state] if params[:state]
    modified[:milestone_id] = params[:milestone][:id] if params[:milestone] && params[:milestone][:id]

    respond_to do |format|
      if @bucket.update_attributes(modified)
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
