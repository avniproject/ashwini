const moment = require("moment");
const _ = require("lodash");
import {
    RuleFactory,
    FormElementsStatusHelper,
    FormElementStatusBuilder,
    FormElementStatus,
    VisitScheduleBuilder
} from 'rules-config/rules';

const AnthropometryViewFilter = RuleFactory("d062907a-690c-44ca-b699-f8b2f688b075", "ViewFilter");

@AnthropometryViewFilter("7d024597-8acc-457a-99be-4deb0db82102", "Don't capture height for 6 months", 1000.0, {})
class AnthropometryHandlerJSS {
    height(programEncounter, formElement) {
        const lastEncounterWithHeight = programEncounter.programEnrolment.findLatestPreviousEncounterWithObservationForConcept(programEncounter, "Height");
        const isHeightNeverCapturedBefore = _.isNil(lastEncounterWithHeight);
        const ageInMonths = programEncounter.programEnrolment.individual.getAgeInMonths(programEncounter.encounterDateTime, false);
        const isAgeInMonthMultipleOf6 = ((ageInMonths % 6) === 0);
        var shouldHeightToBeCapturedThisTime = (isHeightNeverCapturedBefore || isAgeInMonthMultipleOf6);
        return new FormElementStatus(formElement.uuid, shouldHeightToBeCapturedThisTime);
    }

    static exec(programEncounter, formElementGroup) {
        return FormElementsStatusHelper
            .getFormElementsStatuses(new AnthropometryHandlerJSS(), programEncounter, formElementGroup);
    }
}

module.exports = {AnthropometryHandlerJSS};
