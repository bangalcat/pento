defmodule Pento.Mailer do
  use Boundary
  use Swoosh.Mailer, otp_app: :pento
end
