class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :event_owner!, only: [:edit,:update,:destroy]
  respond_to :html, :xml, :json


  def my_events
    @events = current_user.organized_events
  end

  def accept_request
    @event = Event.friendly_id.find_by(params[:id])
    @attendance = Attendance.find_by(id: params[:attendance_id]) rescue nil
    @attendance.state = 'accepted'
    "Applicant Accepted" if @attendance.save
    #render json: (@attendance)
    redirect_to @event
  end

  def reject_request
    @event = Event.friendly_id.find_by(params[:id])
    @attendance = Attendance.find_by(id: params[:attendance_id]) rescue nil
    @attendance.state = 'rejected'
    "Applicant rejected" if @attendance.save
    #render json: (@attendance)
    redirect_to @event
  end

  # GET /events
  # GET /events.json
  def index
    if params[:tag]
      @events = Event.tagged_with(params[:tag])
    else
      @events = Event.all
    end
  end

  def join
    @event = Event.friendly_id.find_by(params[:id])
    @attendance = Attendance.join_event(current_user.id, params[:event_id], 'request_sent')
    flash[:notice] = 'Request Sent' if @attendance.save

    #render json: (@attendance)
    redirect_to @event
  end

  # GET /events/1
  # GET /events/1.json
  def show

    @event_owners = @event.organizer
    @pending_requests = Event.pending_requests(@event.id) 
    @attendees = Event.show_accepted_attendees(@event.id)
  end

  # GET /events/new
  def new
    @event = current_user.organized_events.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = current_user.organized_events.create(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.friendly_id.find(params[:id])
    end

    def event_owner!
      authenticate_user!
        if @event.organizer_id != current_user.id
          redirect_to events_path
          flash[:notice] = 'You do not have enough permissions to do this'
        end
    end  

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:title, :start_date, :end_date, :location, :agenda, :address, :organizer_id, :all_tags)
    end
end
