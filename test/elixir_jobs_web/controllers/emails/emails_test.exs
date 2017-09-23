defmodule ElixirJobsWeb.EmailsTest do
  use ElixirJobsWeb.ConnCase
  use Bamboo.Test, shared: true

  alias ElixirJobs.Offers
  alias ElixirJobs.Users

  import Ecto.Query, only: [from: 2]

  describe "offers" do
    alias ElixirJobs.{
      Offers.Offer
    }

    @valid_offer %{
      title: "some title",
      company: "some company",
      description: "some description",
      location: "some location",
      url: "https://www.google.com",
      job_place: "remote",
      job_type: "full_time"
    }

    @valid_admin_1 %{
      name: "admin1",
      email: "admin1@email.com",
      password: "password",
      password_confirmation: "password"
    }

    @valid_admin_2 %{
      name: "admin2",
      email: "admin2@email.com",
      password: "password",
      password_confirmation: "password"
    }

    test "emails get sent to admins on offer creation", %{conn: conn} do
      Users.create_admin(@valid_admin_1)
      Users.create_admin(@valid_admin_2)
      assert length(Users.list_admins()) == 2
      conn = post conn, offer_path(conn, :create), offer: @valid_offer
      query = Ecto.Query
      offer = ElixirJobs.Repo.one(from offer in ElixirJobs.Offers.Offer, order_by: [desc: offer.inserted_at], limit: 1)
      assert_delivered_email ElixirJobsWeb.Email.notification_offer_created_html(offer)
    end

    test "doesn't raise error without admins on offer creation", %{conn: conn} do
      conn = post conn, offer_path(conn, :create), offer: @valid_offer
      assert redirected_to(conn) == offer_path(conn, :index)
      assert conn.status == 302
      assert get_flash(conn, :info) == "<b>Job offer created correctly!</b> We will review and publish it soon"
      assert_no_emails_delivered
    end

  end

end
