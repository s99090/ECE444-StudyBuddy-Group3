class MeetingsController < ApplicationController
  # before_action :checkIfAllowed

  # def checkIfAllowed
  #   @buddy = Buddy.find(params[:buddy_id])
  #   if @buddy.username != current_user.username && current_user.username != "borhterbeat" #or @buddy.interested_users.include?(current_user.username)
  #     @buddy.errors.add(:courses, "You are not allowed to be here")
  #     puts current_user.username
  #     redirect_to buddies_path
  #   end
  # end

  def index
    @buddy = Buddy.find(params[:buddy_id])
    if @buddy.username != current_user.username
      redirect_to buddies_path
    end
    @meetings = @buddy.meetings.all
  end

  def edit
    @buddy = Buddy.find(params[:buddy_id])
    if @buddy.username != current_user.username
      redirect_to buddies_path
    end

    @meeting = @buddy.meetings.find(params[:id])
  end

  def show

    @buddy = nil
    @meeting = nil
    @amount = 0

    if params[:token] != nil

      @meeting = Meeting.all.find_by_meeting_token(params[:token])

      if @meeting == nil
        flash[:error] = "Meeting link doesn't exist."
        redirect_to buddies_path

      end

      @buddy = Buddy.find(@meeting.buddy_id)
    else
      @buddy = Buddy.find(params[:buddy_id])
      @meeting = @buddy.meetings.find(params[:id])
    end

    unless @buddy.username == current_user.username || current_user.id == @meeting.invitee.to_i
      flash[:error] = "Meeting link doesn't exist."
      redirect_to buddies_path
    end

    @comments = @meeting.comments.all
    @comment = @meeting.comments.build

  end

  def new
    @buddy = Buddy.find(params[:buddy_id])
    if @buddy.username != current_user.username
      redirect_to buddies_path
    end

    @meeting = @buddy.meetings.build
  end

  def create

    @buddy = Buddy.find(params[:buddy_id])

    if @buddy.username != current_user.username
      redirect_to buddies_path
    end

    @meeting = @buddy.meetings.build(params.require(:meeting).permit(:name, :initial_post)) #have to fix this
    @meeting.invitee = params[:meeting][:users]
    @meeting.meeting_token = SecureRandom.urlsafe_base64.to_s

    if params[:meeting][:users] != "" && @meeting.save

      s = view_encrypted_meeting_url(@meeting.meeting_token, host: root_url)
      s += ", "
      s += @buddy.username

      # raise ""

      @user = User.find(@meeting.invitee)
      @user.invited_meetings.push(s)
      @user.save

      MeetingMailer.notify_student_about_meeting(User.find(@meeting.invitee), @buddy, @meeting).deliver_now
      redirect_to buddy_meeting_path(@buddy, @meeting)
      #we need to send a notification to the user that there was a meeting created
    else
      if params[:meeting][:users] == ""
        @meeting.errors.add(:invitee, "can't be empty, you must select a invitee!")
      end
      render 'new'
    end
  end

  def update
    @buddy = Buddy.find(params[:buddy_id])
    if @buddy.username != current_user.username
      redirect_to buddies_path
    end
    @meeting = @buddy.meetings.find(params[:id])


    if @meeting.update(params.require(:meeting).permit(:name, :initial_post))
      redirect_to buddy_meeting_path(@buddy, @meeting)
    else
      render 'edit'
    end

  end

  def destroy
    @buddy = Buddy.find(params[:buddy_id])
    @meeting = @buddy.meetings.find(params[:id])

    if Buddy.find(@meeting.buddy_id).username == current_user.username

      @meeting.destroy
      redirect_to buddy_meetings_url(@buddy)

    else

      @buddy.errors[:base] << "Sorry, you are not the creater of this meeting!"
      render 'show'
    end
  end

end
