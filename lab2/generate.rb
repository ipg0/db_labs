# frozen_string_literal: true

require 'pg'
require 'faker'
require 'date'

PROJECTS = 1000
EMPLOYEES = 100
ASSIGNMENTS = 2000
CONTRACTORS = 100
CONTRACTS = 2000

DB = PG.connect dbname: 'projectdb'

DB.exec File.read('./setup.sql')

PROJECTS.times do
  DB.exec "insert into projects (
            project_name,
            deadline,
            labour
          )
            values (
              '#{DB.escape(Faker::Commerce.unique.product_name)}',
              date '#{Faker::Date.between from: Date.today - 100, to: Date.today + 100}',
              #{rand(100)}
            );"
end

EMPLOYEES.times do
  DB.exec "insert into employees (
            employee_name,
            position
          )
            values (
              '#{DB.escape Faker::Name.unique.name}',
              '#{DB.escape Faker::Job.title}'
            );"
end

ASSIGNMENTS.times do
  DB.exec "insert into assignments (
            project_id,
            employee_id,
            issue_date,
            labour,
            expected_execution_date,
            actual_execution_date
          )
            values (
              #{rand(1..PROJECTS)},
              #{rand(1..EMPLOYEES)},
              date '#{Faker::Date.backward days: 100}',
              #{rand(10)},
              date '#{expected = Faker::Date.between from: Date.today - 100, to: Date.today + 100}',
              #{expected <= Date.today ? "date '#{Faker::Date.backward days: 100}'" : 'null'}
            );"
end

CONTRACTORS.times do
  DB.exec "insert into contractors (
            contractor_name,
            contact_info
          )
            values (
              '#{DB.escape Faker::Company.unique.name}',
              '#{DB.escape Faker::Internet.unique.email}'
            );"
end

CONTRACTS.times do
  DB.exec "insert into contracts (
            item,
            execution_date,
            cost,
            contractor_id,
            project_id
          )
            values (
              '#{DB.escape Faker::Commerce.product_name}',
              date '#{Faker::Date.between from: Date.today - 100, to: Date.today + 100}',
              #{Faker::Commerce.price},
              #{rand(1..CONTRACTORS)},
              #{rand(1..PROJECTS)}
            );"
end
