class DailyPlansController < ApplicationController
  def index
    @daily_plans = DailyPlan.all
  end

  def show
    @daily_plan = DailyPlan.find(params[:id])
  end

  def new
    @daily_plan = DailyPlan.new
  end

  def create
    @daily_plan = DailyPlan.create(
      user: current_user,
      planned_sleep: 8,
      planned_workout_duration: 60,
      planned_workout_type: "strenght",
      planned_nutrition_log: "Protein based meal",
      start_time: "09:00"
    )
    return unless @daily_plan.save

    redirect_to ai_answer_daily_plan_path(@daily_plan)
  end

  def edit
    @daily_plan = DailyPlan.find(params[:id])
  end

  def update
    @daily_plan = DailyPlan.find(params[:id])

    if @daily_plan.update(check_in_params)
      redirect_to daily_plan_path(@daily_plan),
                  notice: "Daily check-in completed!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def ai_answer
    @daily_plan = DailyPlan.find(params[:id])
    @messages = @daily_plan.messages.order(:created_at)
  end

  def ask_ai
    @daily_plan = DailyPlan.find(params[:id])

    user_message = params[:chat][:message]

    @daily_plan.messages.create!(
      role: "user",
      content: user_message
    )

    conversation_history = @daily_plan.messages.order(:created_at).map do |message|
      "#{message.role}: #{message.content}"
    end.join("\n")

    chat = RubyLLM.chat.with_instructions(
      <<~PROMPT
        You are an AI wellness assistant inside a health planning app.

        Current daily plan:
        Planned sleep: #{@daily_plan.planned_sleep}
        Planned workout type: #{@daily_plan.planned_workout_type}
        Planned workout duration: #{@daily_plan.planned_workout_duration}
        Planned nutrition log: #{@daily_plan.planned_nutrition_log}

        Conversation so far:
        #{conversation_history}

        Your job is to guide the user step by step.

        Rules:
        1. If the user expresses a desire, doubt, concern, or goal, respond warmly and suggest 3 clear options.
        2. If the user chooses one option, say "Good choice" and explain briefly why.
        3. After that, ask: "Do you want to make another change, or are you ready to confirm this update?"
        4. If the user wants another change, give 3 new options.
        5. If the user says they are ready, satisfied, done, confirmed, or wants to update the plan, present the final proposed daily plan.
        6. When presenting the final plan, end your response with exactly this phrase:
        READY_FOR_CONFIRMATION

        Keep responses concise, practical, and supportive.
      PROMPT
    )

    ai_response = chat.ask(user_message).content

    @daily_plan.messages.create!(
      role: "assistant",
      content: ai_response
    )

    redirect_to ai_answer_daily_plan_path(@daily_plan)
  end

  def confirm_ai_plan
    @daily_plan = DailyPlan.find(params[:id])

    @ruby_llm_chat = RubyLLM.chat

    @ruby_llm_chat.with_tool(UpdateDailyPlanTool.new(@daily_plan))
    response = @ruby_llm_chat.with_instructions(instructions).ask(update_plan_request)

    redirect_to root_path, notice: "Plan updated successfully"
  end

  private

  def check_in_params
    params.require(:daily_plan).permit(:actual_sleep, :actual_workout_duration, :actual_workout_type,
                                       :actual_nutrition, :workout_feeling)
  end

  def daily_plan_params
    params.require(:daily_plans).permit(:planned_sleep, :planned_workout_duration, :planned_workout_type,
                                        :planned_nutrition_log)
  end

  def instructions
    <<~PROMPT
      You are an AI planning assistant inside a lifestyle tracking application.

      The user has confirmed the plan changes they selected during the conversation.

      Your task is to identify the user's confirmed choices and update the stored plan values.

      You may use the UpdateDailyPlanTool to modify the database record.

      After the update is completed, provide a short confirmation message.
    PROMPT
  end

  def update_plan_request
    <<~PROMPT
      Review the conversation history.

      Identify the user's final confirmed choices.

      Use UpdateDailyPlanTool to apply those changes to the stored plan.

      After the update is completed, return a brief confirmation message.
    PROMPT
  end
end
