const startEndScreens = {
    path: {
        height: "63.5vh",
        width: "60vh",
        icon: "fa-laptop-code",
        start: "Unrecognized user, connection required..",
        failTime: "Connection failed. Time Limit Reached.",
        failError: "Connection failed. Error Limit Reached.",
        success: "Connection successful. Access Granted",
    },
    spot: {
        height: "63vh",
        width: "60vh",
        icon: "fa-file-shield",
        start: "Files encrypted, user bypass required..",
        failTime: "Decryption failed. Time Limit Reached",
        success: "Files successfully decrypted.",
    },
    math: {
        height: "60vh",
        width: "60vh",
        icon: "fa-server",
        start: "Firewall active. Attempting to bypass..",
        failTime: "Bypass failed. Time Limit Reached",
        failError: "Bypass failed. Incorrect input.",
        success: "Firewall successfully bypassed.",
    }
}

let activeGame = null;
let startTimeout = null;
let endTimeout = null;

function startGame(game, settings) {
    switch(game) {
        case "path":
            startPathGame(settings);    
            break;
        case "spot":
            startSpotGame(settings);
            break;
        case "math":
            startMathGame(settings);
            break;
        }
}

function displayScreen(game, text) {
    const screenInfo = startEndScreens[game]
    $("#screen").css({
        "height": screenInfo.height,
        "width" : screenInfo.width,
    })

    $(".screen-icon").html(`<i class="fa-solid ${screenInfo.icon}"></i>`);
    $(".screen-text").text(screenInfo[text]);

    $("#screen").show();
}

function hideScreen() {
    $("#screen").hide();
}

function clearTimeouts() {
    clearTimeout(startTimeout);
    clearTimeout(endTimeout);
}

$(document).keyup(function(e) {
    if (e.key == "Escape" && activeGame) {
        $.post(`https://vs_carstealing/endGame`, JSON.stringify({success: false}));

        if (activeGame == "path") {
            resetPath();
        }

        if (activeGame == "spot") {
            resetSpot();
        }

        if (activeGame == "math") {
            resetMath();
        }
        clearTimeouts();
        activeGame  = null;
    }
})

    
window.addEventListener("message", function(event) {
    const item = event.data;
    if (item.action == "startGame") {
        startGame(item.game, item.settings);
    }
})

const sleep = (delay) => new Promise((resolve) => setTimeout(resolve, delay));

const PushInteract = (async(data) => {
    $(`#interact-wrapper-${data.id}`).remove();
    let $newInteract = $(`
    <div style="top: ${data.position.top}px; left: ${data.position.left}px" class="interact-wrapper close-wrapper" id="interact-wrapper-${data.id}">
        <div class="key-box">E</div>
        <div class="options-list">
        </div>
    </div>`);
    $('body').append($newInteract);
    for (let i in data.options) {
        $(`#interact-wrapper-${data.id} .options-list`).append(`
        <div data-command="${data.options[i].command}" data-type="${data.options[i].type || 'event'}" data-id="${parseInt(i)}" data-event="${data.options[i].event}" data-args="${data.options[i].args}" class="option-wrapper ${i == 0 ? `option-selected` : ``}">
            <div class="option-check"></div>
            <span>${data.options[i].label}</span>
        </div>`);
        await sleep(200);
    }
    // $newInteract.css({
    //     top: data.position.top + 'px',
    //     left: data.position.left + 'px',
    // })
})

window.addEventListener("message", (event) => {
    let data = event.data;
    switch(data.action) {
        case 'ShowInteract':
            if (data.type == 'circle') {
                $(`#interact-wrapper-${data.id}`).remove();
                let $newInteract = $(`
                <div class="interact-wrapper" id="interact-wrapper-${data.id}">
                    <div class="circle">
                        <i class="${data.icon}"></i>
                    </div>
                </div>`)
                $('body').append($newInteract);
                $newInteract.css({
                    top: data.position.top + 'px',
                    left: data.position.left + 'px',
                })
            } else if (data.type == 'all') {
                PushInteract(data);
            }
            break;
        case 'UpdateInteract':
            $(`#interact-wrapper-${data.id}`).css({
                top: data.top + 'px',
                left: data.left + 'px',
            })
            break;
        case 'HideInteract':
            $(`#interact-wrapper-${data.id}`).fadeOut(250);
            break;
        case 'SelectInteract':
            let selectedOption = $(`#interact-wrapper-${data.id} .option-selected`);
            let newSelected = selectedOption.next('.option-wrapper');
            if (newSelected.length < 1) {
                selectedOption.removeClass('option-selected');
                $(`#interact-wrapper-${data.id} .option-wrapper`).first().addClass('option-selected');
            } else {
                selectedOption.removeClass('option-selected');
                newSelected.addClass('option-selected');
            }
            break;
        case 'UseInteract':
            let selected = $(`#interact-wrapper-${data.id} .option-selected`);
            $.post('https://vs_carstealing/UseInteract', JSON.stringify({
                event: selected.attr('data-event'),
                args: selected.attr('data-args'),
                type: selected.attr('data-type'),
                itemId: data.id,
                optionId: selected.attr('data-id'),
                command: selected.attr('data-command')
            }))
            break;
    }
})