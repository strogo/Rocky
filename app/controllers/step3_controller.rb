#***** BEGIN LICENSE BLOCK *****
#
#Version: RTV Public License 1.0
#
#The contents of this file are subject to the RTV Public License Version 1.0 (the
#"License"); you may not use this file except in compliance with the License. You
#may obtain a copy of the License at: http://www.osdv.org/license12b/
#
#Software distributed under the License is distributed on an "AS IS" basis,
#WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the
#specific language governing rights and limitations under the License.
#
#The Original Code is the Online Voter Registration Assistant and Partner Portal.
#
#The Initial Developer of the Original Code is Rock The Vote. Portions created by
#RockTheVote are Copyright (C) RockTheVote. All Rights Reserved. The Original
#Code contains portions Copyright [2008] Open Source Digital Voting Foundation,
#and such portions are licensed to you under this license by Rock the Vote under
#permission of Open Source Digital Voting Foundation.  All Rights Reserved.
#
#Contributor(s): Open Source Digital Voting Foundation, RockTheVote,
#                Pivotal Labs, Oregon State University Open Source Lab.
#
#***** END LICENSE BLOCK *****
class Step3Controller < RegistrationStep
  CURRENT_STEP = 3

  def update
    if params[:javascript_disabled] == "1" && params[:registrant]
      reg = params[:registrant]
      reg[:change_of_address] = !"#{reg[:prev_address]}#{reg[:prev_unit]}#{reg[:prev_city]}#{reg[:prev_zip_code]}".blank?
      reg[:change_of_name] = !"#{reg[:prev_first_name]}#{reg[:prev_middle_name]}#{reg[:prev_last_name]}".blank?
    end
    super
  end

  protected

  def advance_to_next_step
    if @registrant.custom_step_2?
      @registrant.advance_to_step_3
      @registrant.advance_to_step_4
    else
      @registrant.advance_to_step_3
    end
  end

  def next_url
    if @registrant.custom_step_2?
      registrant_step_5_url(@registrant)
    else
      registrant_step_4_url(@registrant)
    end
  end

  def set_up_view_variables
    @registrant.prev_state ||= @registrant.home_state
    @state_id_tooltip = @registrant.state_id_tooltip
    
    @registrant.mailing_state ||= @registrant.home_state
    @state_parties = @registrant.state_parties
    @race_tooltip = @registrant.race_tooltip
    @party_tooltip = @registrant.party_tooltip
    
    @question_1 = @registrant.partner.send("survey_question_1_#{@registrant.locale}")
    @question_2 = @registrant.partner.send("survey_question_2_#{@registrant.locale}")
    
  end
end
