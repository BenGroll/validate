document.addEventListener("DOMContentLoaded", function () {
    
    const validate = document.getElementById("validate");

    if (!validate) {
        return;
    }

    validate.addEventListener("click", function (event) {

        const date = new Date();

        const formattedDate = date.toLocaleString('de-DE');

        event.target.dispatchEvent(new CustomEvent("notify", {
            bubbles: true,
            detail: {
                text: formattedDate + " - Validate!"
            },
        }));

    });

});
