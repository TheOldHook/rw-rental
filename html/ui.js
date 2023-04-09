// Listen for NUI messages
window.addEventListener('message', (event) => {
  const data = event.data;

  if (data.type === 'setDisplay') {
    document.querySelector('.min-h-screen').style.display = data.value ? 'block' : 'none';
  } else if (data.type === 'setVehicles') {
    createVehicleCards(data.vehicles);
  }
});

// Create vehicle cards dynamically
function createVehicleCards(vehicles) {
  console.log('Received vehicles:', vehicles); // debugging
  const container = document.querySelector('.grid');
  container.innerHTML = '';

  vehicles.forEach(vehicle => {
    const card = `
      <div class="group relative" data-hash="${vehicle.hash}" data-price="${vehicle.price}">
        <div class="aspect-h-1 aspect-w-1 w-full overflow-hidden rounded-lg bg-gray-200 xl:aspect-h-8 xl:aspect-w-7">
          <img src="img/${vehicle.image}" alt="${vehicle.name}" class="h-full w-full object-cover object-center group-hover:opacity-75">
        </div>
        <h3 class="mt-4 text-sm text-gray-700">${vehicle.name}</h3>
        <p class="mt-1 text-lg font-medium text-gray-900">kr ${vehicle.price.toLocaleString()},-</p>
        <button class="rent-button bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded absolute bottom-0 right-0 mr-4 mb-4" style="display:none;">Rent</button>
      </div>
    `;

    container.innerHTML += card;
  });

  // Attach click event listeners to rent buttons
  const rentButtons = document.querySelectorAll('.group');
  rentButtons.forEach(button => {
    button.addEventListener('click', (event) => {
      const rentButton = event.currentTarget.querySelector('.rent-button');
      const rentButtons = document.querySelectorAll('.rent-button');
      rentButtons.forEach(button => {
        button.style.display = 'none';
      });
      rentButton.style.display = 'block';
    });
  });

  // Attach click event listeners to each rent button
  const actualRentButtons = document.querySelectorAll('.rent-button');
  actualRentButtons.forEach(button => {
    button.addEventListener('click', (event) => {
      const vehicleHash = event.currentTarget.parentNode.getAttribute('data-hash');
      const vehiclePrice = parseInt(event.currentTarget.parentNode.getAttribute('data-price'), 10);

      // Call the 'rent' NUI callback with the vehicle hash and price
      //window.postMessage({ type: 'rent', vehicleHash, vehiclePrice });
      $.post('https://rw-rental/rent', JSON.stringify({ vehicleHash, vehiclePrice }));
    });
  });
}

// Close button event listener
document.getElementById('close').addEventListener('click', () => {
  window.postMessage({ type: 'close' });
  $.post('https://rw-rental/close', JSON.stringify({}));
});

document.addEventListener('keyup', (event) => {
  if (event.keyCode === 27) {
    window.postMessage({ type: 'close' });
    $.post('https://rw-rental/close', JSON.stringify({}));
  }
});
