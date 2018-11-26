defmodule MehrSchulferienWeb.PageController do
  use MehrSchulferienWeb, :controller

  alias MehrSchulferien.Locations
  alias MehrSchulferien.Locations.FederalState
  alias MehrSchulferien.Locations.Country
  alias MehrSchulferien.Locations.School
  alias MehrSchulferien.Locations.City
  alias MehrSchulferien.Timetables.Category
  alias MehrSchulferien.Timetables.Period
  alias MehrSchulferien.Repo
  alias MehrSchulferien.CollectData
  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    {country, federal_states} = get_locations("deutschland")
    {starts_on, ends_on} = get_dates()
    categories = get_categories()
    religion_categories = get_religion_categories()

    school_counter = Repo.one(from p in School, select: count("*"))

    days = CollectData.list_days([country] ++ federal_states,
                                 starts_on: starts_on, ends_on: ends_on)

    render(conn, "index.html", federal_states: federal_states,
                               country: country,
                               days: days,
                               categories: categories,
                               religion_categories: religion_categories,
                               school_counter: school_counter)
  end

  def developers(conn, _params) do
    city_counter = Repo.one(from p in City, select: count("*"))
    school_counter = Repo.one(from p in School, select: count("*"))
    period_counter = Repo.one(from p in Period, select: count("*"))

    country = Locations.get_country!("deutschland")

    query = from fs in FederalState, where: fs.country_id == ^country.id,
                                     order_by: fs.name
    federal_states = Repo.all(query)

    render(conn, "developers.html", city_counter: city_counter,
                                    school_counter: school_counter,
                                    period_counter: period_counter,
                                    federal_states: federal_states)
  end

  def impressum(conn, _params) do
    city_counter = Repo.one(from p in City, select: count("*"))
    school_counter = Repo.one(from p in School, select: count("*"))
    period_counter = Repo.one(from p in Period, select: count("*"))

    country = Locations.get_country!("deutschland")

    query = from fs in FederalState, where: fs.country_id == ^country.id,
                                     order_by: fs.name
    federal_states = Repo.all(query)

    render(conn, "impressum.html", city_counter: city_counter,
                                    school_counter: school_counter,
                                    period_counter: period_counter,
                                    federal_states: federal_states)
  end

  defp get_locations(id) do
    country = Locations.get_country!(id)

    query = from fs in FederalState, where: fs.country_id == ^country.id,
                                     order_by: fs.name,
                                     preload: [:cities, :schools]
    federal_states = Repo.all(query)

    {country, federal_states}
  end

  defp get_religion_categories() do
    query = from c in Category, where: c.for_students == true and
                                       c.is_a_religion == true
    Repo.all(query)
  end

  defp get_dates(starts_on \\ nil, ends_on \\ nil) do
    {starts_on, ends_on} =
      case {starts_on, ends_on} do
        {nil, nil} ->
          {:ok, starts_on} = Date.from_erl({Date.utc_today.year, Date.utc_today.month, 1})
          ends_on = Date.add(starts_on, 364)
          {starts_on, ends_on}
        {starts_on, ends_on} -> {:ok, starts_on} = Ecto.Date.cast(starts_on)
                                {:ok, ends_on} = Ecto.Date.cast(ends_on)
                                {:ok, starts_on} = Date.from_erl(Ecto.Date.to_erl(starts_on))
                                {:ok, ends_on} = Date.from_erl(Ecto.Date.to_erl(ends_on))
                                {starts_on, ends_on}
      end

    CollectData.ramp_up_to_full_months(starts_on, ends_on)
  end

  defp get_categories() do
    query = from c in Category, where: c.for_students == true and
                                       "Wochenende" != c.name
    Repo.all(query)
  end

  defp get_religion_categories() do
    query = from c in Category, where: c.for_students == true and
                                       c.is_a_religion == true
    Repo.all(query)
  end
end
