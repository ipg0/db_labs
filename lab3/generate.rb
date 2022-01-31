# frozen_string_literal: true

require 'pg'
require 'faker'
require 'date'
require 'json'

PROJECTS = 10_000
EMPLOYEES = 100_000
ASSIGNMENTS = 1_000_000
CONTRACTORS = 10_000
CONTRACTS = 20_000

DB = PG.connect dbname: 'projectdb_analytic'

project_contracts = [[]] * PROJECTS
employee_overdue_assignments = [0] * EMPLOYEES
contractor_projects = [Set[]] * CONTRACTORS

puts 'Creating tables...'

DB.exec File.read('./setup.sql')

puts 'Generating contracts...'

CONTRACTS.times do |i|
  DB.exec "insert into contracts (
            item,
            execution_date,
            cost,
            contractor_id,
            project_id
          )
            values (
              '#{DB.escape(item = Faker::Commerce.product_name)}',
              date '#{execution_date = (Faker::Date.between from: Date.today - 100, to: Date.today + 100)}',
              #{cost = Faker::Commerce.price},
              #{contractor = rand(1..CONTRACTORS)},
              #{
                cur = rand(1..PROJECTS)
                project_contracts[cur - 1] << JSON.unparse({
                                                             item: item,
                                                             execution_date: execution_date.to_s,
                                                             cost: cost,
                                                             contractor: contractor
                                                           })
                contractor_projects[contractor - 1].add cur
                cur
              }
            );"
  puts 100.0 * i / CONTRACTS if cur % 200 == 0
end

puts 'Generating projects...'

PROJECTS.times do |cur|
  DB.exec "insert into projects (
            project_name,
            deadline,
            labour,
            contracts
          )
            values (
              '#{DB.escape(Faker::Commerce.product_name)}',
              date '#{Faker::Date.between from: Date.today - 100, to: Date.today + 100}',
              #{rand(100)},
              '#{project_contracts[cur]}'
            );"

  puts 100.0 * cur / PROJECTS if cur % 100 == 0
end

puts 'Generating assignments...'

ASSIGNMENTS.times do |i|
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
              #{employee = rand(1..EMPLOYEES)},
              date '#{Faker::Date.between from: Date.today - 100, to: Date.today - 20}',
              #{rand(10)},
              date '#{expected = Faker::Date.between from: Date.today - 20, to: Date.today + 100}',
              #{if expected <= Date.today
                  "date '#{
                    actual = Faker::Date.between from: Date.today - 20, to: Date.today + 100
                    employee_overdue_assignments[employee - 1] += 1 if actual > expected
                    actual
                  }'"
                else
                  'null'
                end}
            );"
  puts 100.0 * i / ASSIGNMENTS if i % 100_000 == 0
end

puts 'Generating employees...'

EMPLOYEES.times do |cur|
  DB.exec "insert into employees (
            employee_name,
            position,
            overdue_assignments
          )
            values (
              '#{DB.escape Faker::Name.name}',
              '#{DB.escape Faker::Job.title}',
              #{employee_overdue_assignments[cur]}
            );"
  puts 100.0 * cur / EMPLOYEES if cur % 10_000 == 0
end

puts 'Generating contractors...'

CONTRACTORS.times do |cur|
  DB.exec "insert into contractors (
            contractor_name,
            contact_info,
            projects
          )
            values (
              '#{DB.escape Faker::Company.name}',
              '#{DB.escape Faker::Internet.email}',
              '{#{contractor_projects[cur].reduce { |cat, e| "#{cat}, #{e}" }}}'
            );"
  puts 100.0 * cur / CONTRACTORS if cur % 100 == 0
end

puts 'Setting up constraints...'

DB.exec File.read('./setup_constraints.sql')
