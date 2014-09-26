function getAbsenceDataForGivenUrl(selector, url) {
    $.ajax({
        type: 'GET',
        data: { holiday_year_id: selector.val() },
        url: url
    });
}

function initDatePickers(selectorToUseAsDatePicker, selectorToChangeOnClose, option) {
    $(selectorToUseAsDatePicker).datepicker({
        dateFormat: 'dd/mm/yy',
        changeMonth: true,
        changeYear: true,
        beforeShowDay: $.datepicker.noWeekends,
        onClose: function( selectedDate ) {
            $(selectorToChangeOnClose).datepicker( "option", option, selectedDate );
        }
    });
}