module Headlines
  class GenerateEmailParams
    include Interactor

    GRADES = ["D", "C", "B", "A"]

    delegate :params, :ssl_enabled, :for_email, to: :context

    def call
      return unless for_email

      context.email_params = {
        status: GRADES[score],
        http_grade: GRADES[http_score],
        csp_grade: GRADES[csp_score],
        http_headers: http_headers,
        csp_header: csp_header
      }
    end

    private

    def score
      params[:score]
    end

    def http_score
      params[:http_score]
    end

    def csp_score
      params[:csp_score]
    end

    def http_headers
      params[:http_headers].map do |header|
        {
          status: status_by_rating(header[:rating]),
          label: header_label(header),
          title: header_title(header),
          description: header_description(header)
        }
      end
    end

    def header_label(header)
      I18n.t("js.headlines.tests.#{header[:name]}.label")
    end

    def header_title(header)
      return present_title(header) if header[:score] > 0
      return missing_title(header) unless header[:name] == "strict-transport-security"

      ssl_enabled ? missing_title(header) : "TLS/SSL is not enabled"
    end

    def header_description(header)
      I18n.t("js.headlines.tests.#{header[:name]}.score#{header[:score]}")
    end

    def present_title(header)
      [I18n.t("js.headlines.tests.#{header[:name]}.title"), ": ", header[:value]].join("")
    end

    def missing_title(header)
      [I18n.t("js.headlines.header_missing"), I18n.t("js.headlines.tests.#{header[:name]}.title")].join(" ")
    end

    def csp_header
      {
        directives: csp_directives,
        tests: csp_tests
      }
    end

    def csp_directives
      params[:csp_header][:value] && params[:csp_header][:value].split(";")
    end

    def csp_tests
      params[:csp_header][:tests].map do |test|
        {
          applicable?: applicable?(test),
          status: status_by_score(test[:score]),
          title: csp_test_title(test),
          description: csp_test_description(test)
        }
      end
    end

    def applicable?(test)
      test[:score] != 0
    end

    def csp_test_title(test)
      I18n.t("js.headlines.tests.content-security-policy.#{test[:name]}.title")
    end

    def csp_test_description(test)
      I18n.t("js.headlines.tests.content-security-policy.#{test[:name]}.description")
    end

    def status_by_score(score)
      if score > 0
        'status-success'
      elsif score < 0
        'status-danger'
      else
        'status-warning'
      end
    end

    def status_by_rating(rating)
      if rating == "OK"
        "status-success"
      elsif rating == "ERROR"
        "status-danger"
      else
        "status-warning"
      end
    end
  end
end
