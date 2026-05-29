class CreateHelpTicketTool < RubyLLM::Tool
  description "Creates a daily plan based on the log the user is giving you."
  param :planned_nutrition_log, desc: "The ID of the challenge", type: :integer
  param :teacher_name, desc: "The name of the available teacher"

  def initialize(user:)
    @user = user
  end

  def execute(challenge_id:, teacher_name:)
    challenge = Challenge.find(challenge_id)
    ticket = HelpTicket.create!(
      user: @user,
      challenge: challenge,
      teacher_name: teacher_name,
      status: "pending"
    )
    { status: "created", ticket_id: ticket.id, challenge: challenge.name, teacher: teacher_name }
  rescue ActiveRecord::RecordNotFound
    { error: "Challenge not found" }
  rescue ActiveRecord::RecordInvalid => e
    { error: e.message }
  end
end