class LinksController < ApplicationController
    def index 
        @courses = Course.all
        @course = Course.find(params["course_id"])
        # @links = Link.where(course_id: @course.id)
        @links = @course.links.all
        @abc = @course.links.all
    end

    def new
        @course = Course.find(params[:course_id])
        @links = @course.links.build
    end

    def create 
        @course = Course.find(params["course_id"])
        @link = @course.links.build(params.require(:link).permit(:link_name, :link_url, :course_id, :creater_id))
        @link.course_id = @course.id
        @link.creater_id = current_user.id

        if @link.save
            flash[:Success] = "You have successfully added a link."
            redirect_to course_links_path
          else
            flash[:Error] = "You must provide a valid http or https link."
            render 'new'
          end
    end

    def show
        @course = Course.find(params[:course_id])
        @link = Link.find(params[:id])
        @abc = @course.links.all
    end

    def addUpvote
        @course = Course.find(params[:course_id])
        @link = Link.find(params[:link_id])
        if not (@link.upvotes.include? (current_user.id).to_s)
           if not (@link.downvotes.include? (current_user.id).to_s)
                @link.upvotes << (current_user.id)
                @link.save
                redirect_to course_links_path
           else
                
                @link.upvotes << (current_user.id)
                @link.downvotes.pop(current_user.id)
                @link.save
                redirect_to course_links_path
           end
        else
            flash[:Notice] = "You have already upvoted this link"
            redirect_to course_links_path
        end
        
    end
    def addDownvote
        @course = Course.find(params[:course_id])
        @link = Link.find(params[:link_id])
        if not (@link.downvotes.include? (current_user.id).to_s)
           if not (@link.upvotes.include? (current_user.id).to_s)
                @link.downvotes << (current_user.id)
                @link.save
                redirect_to course_links_path
           else
                #need to raise an error here

                @link.downvotes << (current_user.id)
                @link.upvotes.pop(current_user.id)
                @link.save
                redirect_to course_links_path
           end
        else
            flash[:Notice] = "You have already downvoted this link"
            redirect_to course_links_path
        end
    end
end



