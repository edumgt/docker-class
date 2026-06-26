const ordersList = document.getElementById("orders-list");
const statusBox = document.getElementById("status-box");
const ordersCount = document.getElementById("orders-count");
const deliveriesCount = document.getElementById("deliveries-count");
const completionRate = document.getElementById("completion-rate");

const orderForm = document.getElementById("order-form");
const deliveryForm = document.getElementById("delivery-form");
const completeForm = document.getElementById("complete-form");
const refreshButton = document.getElementById("refresh-button");

function setStatus(message, tone = "neutral") {
  const tones = {
    neutral: "bg-white/5 text-gray-200",
    success: "bg-emerald-500/15 text-emerald-200",
    error: "bg-red-500/15 text-red-200",
  };
  statusBox.className = `mt-4 rounded-2xl p-4 text-sm leading-6 ${tones[tone]}`;
  statusBox.textContent = message;
}

function badgeClass(status) {
  if (status === "COMPLETED" || status === "DELIVERED") {
    return "bg-emerald-100 text-emerald-700";
  }
  if (status === "REQUESTED") {
    return "bg-amber-100 text-amber-700";
  }
  return "bg-slate-100 text-slate-700";
}

function formatDate(value) {
  return new Date(value).toLocaleString("ko-KR");
}

async function fetchJson(url, options = {}) {
  const response = await fetch(url, options);
  if (!response.ok) {
    const error = await response.json().catch(() => ({ detail: "Request failed" }));
    throw new Error(error.detail || "Request failed");
  }
  return response.json();
}

function renderOrders(orders, deliveries) {
  if (!orders.length) {
    ordersList.innerHTML = `
      <div class="rounded-3xl border border-dashed border-gray-200 bg-gray-50 px-6 py-12 text-center text-gray-500">
        아직 생성된 주문이 없습니다. 오른쪽 폼에서 첫 주문을 만들어보세요.
      </div>
    `;
    return;
  }

  const deliveryMap = new Map(deliveries.map((delivery) => [delivery.order_id, delivery]));

  ordersList.innerHTML = orders
    .map((order) => {
      const delivery = deliveryMap.get(order.id);
      return `
        <article class="rounded-3xl border border-gray-100 bg-gradient-to-r from-white to-gray-50 p-5">
          <div class="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
            <div>
              <div class="flex flex-wrap items-center gap-2">
                <h3 class="text-xl font-bold">주문 #${order.id}</h3>
                <span class="rounded-full px-3 py-1 text-xs font-semibold ${badgeClass(order.status)}">${order.status}</span>
              </div>
              <p class="mt-3 text-sm text-gray-600">고객명: ${order.customer_name}</p>
              <p class="mt-1 text-sm text-gray-600">상품명: ${order.product_name}</p>
              <p class="mt-1 text-sm text-gray-600">수량: ${order.quantity}</p>
              <p class="mt-1 text-sm text-gray-400">주문 시각: ${formatDate(order.created_at)}</p>
            </div>
            <div class="min-w-[240px] rounded-2xl bg-white p-4 ring-1 ring-gray-100">
              <p class="text-sm font-semibold text-gray-700">배송 정보</p>
              ${
                delivery
                  ? `
                    <p class="mt-3 text-sm text-gray-600">배송 ID: ${delivery.id}</p>
                    <p class="mt-1 text-sm text-gray-600">주소: ${delivery.address}</p>
                    <p class="mt-1 text-sm">
                      <span class="rounded-full px-3 py-1 text-xs font-semibold ${badgeClass(delivery.status)}">${delivery.status}</span>
                    </p>
                    <p class="mt-1 text-sm text-gray-400">요청 시각: ${formatDate(delivery.requested_at)}</p>
                    <p class="mt-1 text-sm text-gray-400">완료 시각: ${delivery.delivered_at ? formatDate(delivery.delivered_at) : "-"}</p>
                  `
                  : `<p class="mt-3 text-sm text-gray-400">아직 배송 요청이 없습니다.</p>`
              }
            </div>
          </div>
        </article>
      `;
    })
    .join("");
}

function updateMetrics(orders, deliveries) {
  ordersCount.textContent = String(orders.length);
  deliveriesCount.textContent = String(deliveries.length);
  const completed = orders.filter((order) => order.status === "COMPLETED").length;
  const rate = orders.length ? Math.round((completed / orders.length) * 100) : 0;
  completionRate.textContent = `${rate}%`;
}

async function refreshData() {
  try {
    const [orders, deliveries] = await Promise.all([
      fetchJson("/orders"),
      fetchJson("/deliveries"),
    ]);
    renderOrders(orders, deliveries);
    updateMetrics(orders, deliveries);
    setStatus("데이터를 최신 상태로 불러왔습니다.");
  } catch (error) {
    setStatus(error.message, "error");
  }
}

orderForm.addEventListener("submit", async (event) => {
  event.preventDefault();
  const formData = new FormData(orderForm);
  const payload = {
    customer_name: formData.get("customer_name"),
    product_name: formData.get("product_name"),
    quantity: Number(formData.get("quantity")),
  };

  try {
    const order = await fetchJson("/orders", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });
    orderForm.reset();
    orderForm.quantity.value = 1;
    setStatus(`주문 #${order.id} 이 생성되었습니다.`, "success");
    await refreshData();
  } catch (error) {
    setStatus(error.message, "error");
  }
});

deliveryForm.addEventListener("submit", async (event) => {
  event.preventDefault();
  const formData = new FormData(deliveryForm);
  const orderId = formData.get("order_id");
  const payload = { address: formData.get("address") };

  try {
    const delivery = await fetchJson(`/orders/${orderId}/delivery-request`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });
    deliveryForm.reset();
    setStatus(`배송 #${delivery.id} 요청이 생성되었습니다.`, "success");
    await refreshData();
  } catch (error) {
    setStatus(error.message, "error");
  }
});

completeForm.addEventListener("submit", async (event) => {
  event.preventDefault();
  const formData = new FormData(completeForm);
  const deliveryId = formData.get("delivery_id");

  try {
    const delivery = await fetchJson(`/deliveries/${deliveryId}/complete`, {
      method: "PATCH",
    });
    completeForm.reset();
    setStatus(`배송 #${delivery.id} 이 완료 처리되었습니다.`, "success");
    await refreshData();
  } catch (error) {
    setStatus(error.message, "error");
  }
});

refreshButton.addEventListener("click", refreshData);

refreshData();
