class ScoresController < ApplicationController

  before_action :logged_in_user

  before_action :set_user

  def index
    @scores = if params[:all] == '1'
                Score.all.order(points: :desc).limit(10)
              else
                @scores = Score.where(user: User.find(session[:user_id])).order(points: :desc)
              end
  end

  def create
    render json: 'Forbidden', status: :forbidden and return if params[:palindrome].blank?

    points = score_palindrome(params[:palindrome])

    if points > 0
      @score = Score.create!(points: points, user: current_user, palindrome: params[:palindrome])

      flash[:success] = "You created a palindrome and scored #{@score.points} points!"
      redirect_to scores_path
    else
      flash[:danger] = "Your input was not a palindrome. :( "
      redirect_to new_score_path
    end
  end

  private

  def score_params
    params.permit(:palindrome, :token)
  end

  def score_palindrome(text)
    return 0 unless palindrome?(text)

    total = 0
    arr = text.scan(/\w/)

    prev1 = nil
    prev2 = nil
    arr.each_with_index do |char, index|
      # Dont add points if over 2 recurring letters
      prev2 = prev1
      prev1 = char

      # Dont add points if character was on two previous slots (third character does not add points)
      # Theoretically could penalize a two-word palindrome in which the first word ends with the double-vowel
      # And the next word begins with the same one. However, this is a very niché case
      unless prev1.present? && prev2 == prev1

        # Add score based on character position in string
        if index < 10
          total += 3
        elsif index >= 10 && index < 20
          total += 2
        elsif index > 20
          total += 1
        end
      end
    end
    total
  end

  def palindrome?(string)
    to_eval = string.downcase.gsub(/\s+/, "").gsub(/[^0-9A-Za-z]/, '')

    to_eval.reverse == to_eval
  end

  private

  def set_user
    @user = current_user
  end
end
