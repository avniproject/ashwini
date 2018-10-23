const moment = require("moment");
const _ = require("lodash");
import {
    RuleFactory,
    FormElementsStatusHelper,
    FormElementStatusBuilder,
    FormElementStatus,
    VisitScheduleBuilder
} from 'rules-config/rules';

const EnrolmentChecklists = RuleFactory("1608c2c0-0334-41a6-aab0-5c61ea1eb069", "Checklists");

@EnrolmentChecklists("10dfa1cd-9537-4db7-bd16-870384729da3", "Ashwini Child Vaccination checklists", 100.0)
class ChildChecklists {
    static exec(enrolment, checklistDetails) {
        let vaccination = checklistDetails.find(cd => cd.name === 'Vaccination');
        if (vaccination === undefined) return [];
        const vaccinationList = {
            baseDate: enrolment.individual.dateOfBirth,
            detail: {uuid: vaccination.uuid},
            items: vaccination.items.map(vi => ({
                detail: {uuid: vi.uuid}
            }))
        };
        return [vaccinationList];
    }
}

module.exports = {ChildChecklists};
