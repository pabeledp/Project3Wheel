/* =========================================================
   PROJECT 3 WHEEL - LIQUID GLASS REAL-TIME DYNAMIC ENGINE
   Authentication, User Profile Management & Real Assigned Data
   ========================================================= */

const todayIso = new Date().toISOString().split('T')[0];

// Clean Real Assigned Initial State (Clean Fleet & Clean Ledgers)
const defaultRickshaws = [
  { id: 'R-01', model: 'Mishuk Classic 48V', rate: 350, status: 'active', driverId: 'D-101' },
  { id: 'R-02', model: 'Speedy Eco 60V', rate: 350, status: 'active', driverId: 'D-102' },
  { id: 'R-03', model: 'Runner Turbo 48V', rate: 350, status: 'maintenance', driverId: null },
];

const defaultDrivers = [
  { id: 'D-101', name: 'Karim Ullah', phone: '01711223344', nid: '19882691234567890', agreedDailyRate: 350, due: 0, activeRickshaw: 'R-01', address: 'Mirpur-10, Dhaka', joinDate: todayIso },
  { id: 'D-102', name: 'Rafiqul Islam', phone: '01812345678', nid: '19922699876543210', agreedDailyRate: 350, due: 0, activeRickshaw: 'R-02', address: 'Kalyanpur, Dhaka', joinDate: todayIso },
];

// Clean empty state for collections and expenses (Only real-time assigned data logged by owner)
const defaultCollections = [];
const defaultExpenses = [];

const defaultUserProfile = {
  name: 'Habib Rahman',
  garageName: 'Habib Electric Garage',
  phone: '01711223344',
  email: 'owner@project3wheel.com',
  role: 'owner',
  isAuthenticated: false
};

// --- Translations Dictionary (English & Bengali) ---
const i18n = {
  en: {
    nav_dashboard: "Dashboard",
    nav_collections: "Collections",
    nav_expenses: "Expenses",
    nav_drivers: "Driver Directory",
    nav_reports: "P&L Reports",
    nav_gps: "GPS Telematics",
    badge_soon: "SOON",
    btn_switch_role: "Switch to Manager",
    btn_logout: "Logout",
    modal_profile_title: "User Profile & Garage Settings",
    lbl_profile_name: "Full Name",
    lbl_garage_title: "Garage / Fleet Title",
    lbl_email: "Email Address",
    lbl_role: "Active Role",
    btn_save_profile: "Save Profile",
    auth_tagline: "Electric Rickshaw Fleet Hub & Financial Ledger",
    role_owner: "Fleet Owner",
    role_manager: "Garage Manager",
    lbl_email_or_phone: "Email or Mobile Number",
    lbl_password: "Security Password / PIN",
    btn_sign_in: "Sign In to Fleet Hub",
    page_title_dashboard: "Fleet Overview",
    page_subtitle_dashboard: "Real-time collections, garage rent, and net profit",
    cal_today: "Today",
    cal_yesterday: "Yesterday",
    cal_all_time: "All Time",
    btn_deposit: "Deposit",
    btn_expense: "Expense",
    btn_add_driver: "Driver",
    btn_scan_qr: "Scan QR",
    btn_download_apk: "Download App",
    metric_rickshaw_joma: "Rickshaw Collections",
    metric_garage_rent: "Garage Rent Cost",
    metric_other_expenses: "Other Expenses",
    metric_net_profit: "Owner Net Profit",
    metric_cumulative_dues: "Total Pending Dues",
    lbl_rate: "Rate",
    lbl_daily_rent: "Daily Fixed",
    lbl_repairs: "Repairs",
    lbl_surplus: "Net Surplus",
    lbl_formula: "Joma - Costs",
    lbl_debtors: "Debtors",
    lbl_receivable: "Receivable",
    chart_revenue_velocity: "7-Day Revenue Velocity",
    legend_collections: "Collections",
    legend_expenses: "Expenses",
    fleet_health_title: "Fleet Status",
    btn_add_rickshaw: "Add Rickshaw",
    lbl_total_fleet: "Registered Fleet",
    lbl_active_road: "Active on Road",
    lbl_in_maintenance: "In Maintenance",
    lbl_total_drivers: "Registered Drivers",
    today_joma_tracker_title: "Today's Collections Status",
    btn_export_pdf: "Export PDF",
    th_driver: "Driver",
    th_phone: "Phone",
    th_rickshaw: "Rickshaw",
    th_agreed_rate: "Target Joma",
    th_joma_status: "Deposit Status",
    th_deposited: "Deposited",
    th_due: "Due Amount",
    th_status: "Status",
    th_actions: "Actions",
    collections_ledger_title: "Collections Ledger",
    btn_new_deposit: "New Deposit",
    btn_pdf_report: "PDF Report",
    btn_excel_export: "Excel Export",
    opt_all_status: "All Statuses",
    opt_paid: "Fully Paid",
    opt_due: "Partial Due",
    opt_unpaid: "Unpaid",
    th_date_time: "Date & Time",
    th_expected: "Target",
    th_garage_rent: "Garage Rent",
    th_logged_by: "Logged By",
    expenses_tracker_title: "Garage & Fleet Expenses",
    btn_add_expense: "Add Expense",
    th_date: "Date",
    th_category: "Category",
    th_amount: "Amount",
    th_description: "Description",
    driver_directory_title: "Driver Directory & Profiles",
    btn_add_new_driver: "Add New Driver",
    btn_defaulters_pdf: "Defaulters PDF",
    chk_only_defaulters: "Only Defaulters",
    pnl_statement_title: "Profit & Loss Statement (P&L)",
    btn_pnl_pdf: "P&L PDF",
    btn_excel_audit: "Excel Audit",
    pnl_gross_collections: "Gross Collections",
    pnl_total_expenses: "Total Expenses (Rent + Repair)",
    pnl_net_profit: "Owner's Net Profit",
    pnl_cat_distribution: "Expenditure Distribution",
    gps_title: "GPS Fleet Tracking",
    gps_desc: "Real-time live location, speed monitoring, and telemetry will be available in the upcoming firmware release.",
    modal_qr_title: "QR Scanner",
    qr_align_text: "Align QR code in frame",
    qr_quick_presets: "Test Scanner Presets:",
    lbl_driver: "Driver:",
    lbl_agreed_rate: "Agreed Joma:",
    lbl_due: "Due Balance:",
    btn_record_deposit: "Record Deposit",
    modal_deposit_title: "Record Rental Deposit",
    lbl_target: "Target",
    lbl_remaining_due: "Remaining Due",
    lbl_select_rickshaw: "Select Rickshaw",
    lbl_driver_info: "Driver Information",
    lbl_agreed_joma_rate: "Agreed Joma Target (৳)",
    lbl_amount_deposited: "Amount Deposited (৳)",
    lbl_quick_presets: "Quick Presets:",
    lbl_deduct_garage_rent: "Deduct Daily Garage Rent",
    lbl_rent_amount: "Rent Amount:",
    btn_save_deposit: "Confirm Deposit",
    modal_expense_title: "Track Expense",
    lbl_category: "Category",
    cat_parts: "Parts & Battery",
    cat_mechanic: "Mechanic Labor",
    cat_rent: "Garage Rent & Power",
    cat_line_fee: "Line / Union Fee",
    cat_other: "Miscellaneous",
    lbl_amount: "Amount (৳)",
    lbl_description: "Description / Note",
    lbl_receipt: "Receipt / Voucher (Optional)",
    lbl_attach_receipt: "Attach receipt photo",
    btn_save_expense: "Save Expense",
    modal_add_driver_title: "Add Driver",
    lbl_full_name: "Full Name",
    lbl_phone: "Mobile Number",
    lbl_agreed_daily_rate: "Agreed Daily Joma Rate (৳/day)",
    lbl_nid: "National ID (NID)",
    lbl_address: "Residential Address",
    lbl_assign_rickshaw: "Assign Rickshaw",
    lbl_initial_due: "Opening Due Balance (৳)",
    btn_register_driver: "Register Driver",
    modal_edit_driver_title: "Edit Driver Profile",
    btn_update_profile: "Update Profile",
    modal_add_rickshaw_title: "Add Rickshaw",
    lbl_rickshaw_id: "Rickshaw ID",
    lbl_model_type: "Model & Specs",
    lbl_standard_rate: "Standard Rent Rate (৳/day)",
    btn_save_rickshaw: "Add Rickshaw",
    modal_collect_due_title: "Collect Due",
    lbl_current_due: "Current Due:",
    lbl_payment_amount: "Payment Amount (৳)",
    btn_confirm_payment: "Submit Payment",
    modal_sms_title: "Send SMS Reminder",
    lbl_recipient: "Recipient:",
    btn_cancel: "Cancel",
    btn_send_now: "Send Now",
  },
  bn: {
    nav_dashboard: "ড্যাশবোর্ড",
    nav_collections: "কালেকশন লেজার",
    nav_expenses: "গ্যারেজ খরচ",
    nav_drivers: "ড্রাইভার তালিকা",
    nav_reports: "লাভ-ক্ষতি রিপোর্ট",
    nav_gps: "জিপিএস ট্র্যাকিং",
    badge_soon: "শীঘ্রই",
    btn_switch_role: "ম্যানেজার ভিউ",
    btn_logout: "লগআউট",
    modal_profile_title: "ইউজার প্রোফাইল ও গ্যারেজ সেটিংস",
    lbl_profile_name: "পূর্ণ নাম",
    lbl_garage_title: "গ্যারেজ / ফ্লিট নাম",
    lbl_email: "ইমেইল অ্যাড্রেস",
    lbl_role: "অ্যাক্টিভ রোল",
    btn_save_profile: "প্রোফাইল সেভ করুন",
    auth_tagline: "ইলেকট্রিক রিকশা ফ্লিট হাব ও আর্থিক লেজার",
    role_owner: "ফ্লিট মালিক",
    role_manager: "গ্যারেজ ম্যানেজার",
    lbl_email_or_phone: "ইমেইল বা মোবাইল নম্বর",
    lbl_password: "সিকিউরিটি পাসওয়ার্ড / পিন",
    btn_sign_in: "লগইন করুন",
    page_title_dashboard: "ফ্লিট ওভারভিউ",
    page_subtitle_dashboard: "দৈনিক জমা, গ্যারেজ ভাড়া এবং প্রকৃত লাভের হিসাব",
    cal_today: "আজ",
    cal_yesterday: "গতকাল",
    cal_all_time: "সর্বমোট",
    btn_deposit: "জমা",
    btn_expense: "খরচ",
    btn_add_driver: "ড্রাইভার",
    btn_scan_qr: "স্ক্যান কিউআর",
    btn_download_apk: "অ্যাপ ডাউনলোড",
    metric_rickshaw_joma: "রিকশার মোট জমা",
    metric_garage_rent: "গ্যারেজ ভাড়া খরচ",
    metric_other_expenses: "অন্যান্য খরচ",
    metric_net_profit: "মালিকের খাঁটি লাভ",
    metric_cumulative_dues: "মোট বকেয়া পাওনা",
    lbl_rate: "রেট",
    lbl_daily_rent: "দৈনিক ফিক্সড",
    lbl_repairs: "মেরামত",
    lbl_surplus: "খাঁটি উদ্বৃত্ত",
    lbl_formula: "জমা - খরচ",
    lbl_debtors: "বকেয়াদাতা",
    lbl_receivable: "পাওনা",
    chart_revenue_velocity: "৭-দিনের আয়-ব্যয় ভেলোসিটি",
    legend_collections: "মোট জমা",
    legend_expenses: "মোট খরচ",
    fleet_health_title: "ফ্লিট স্ট্যাটাস",
    btn_add_rickshaw: "রিকশা যুক্ত করুন",
    lbl_total_fleet: "নিবন্ধিত মোট রিকশা",
    lbl_active_road: "রাস্তায় সচল",
    lbl_in_maintenance: "গ্যারেজে মেরামত চলছে",
    lbl_total_drivers: "নিবন্ধিত চালক",
    today_joma_tracker_title: "আজকের চালকদের জমা ট্র্যাকার",
    btn_export_pdf: "পিডিএফ এক্সপোর্ট",
    th_driver: "চালক",
    th_phone: "মোবাইল",
    th_rickshaw: "রিকশা",
    th_agreed_rate: "টার্গেট জমা",
    th_joma_status: "জমার স্ট্যাটাস",
    th_deposited: "জমা হয়েছে",
    th_due: "বকেয়া",
    th_status: "স্ট্যাটাস",
    th_actions: "অ্যাকশন",
    collections_ledger_title: "দৈনিক জমার লেজার",
    btn_new_deposit: "নতুন জমা",
    btn_pdf_report: "পিডিএফ রিপোর্ট",
    btn_excel_export: "এক্সেল এক্সপোর্ট",
    opt_all_status: "সব স্ট্যাটাস",
    opt_paid: "সম্পূর্ণ পরিশোধিত",
    opt_due: "আংশিক বাকি",
    opt_unpaid: "পরিশোধহীন",
    th_date_time: "তারিখ ও সময়",
    th_expected: "টার্গেট",
    th_garage_rent: "গ্যারেজ জমা",
    th_logged_by: "সংগ্রাহক",
    expenses_tracker_title: "গ্যারেজ ও ফ্লিট খরচ",
    btn_add_expense: "খরচ যোগ করুন",
    th_date: "তারিখ",
    th_category: "ক্যাটাগরি",
    th_amount: "পরিমাণ",
    th_description: "বিবরণ",
    driver_directory_title: "ড্রাইভার ডিরেক্টরি ও প্রোফাইল",
    btn_add_new_driver: "নতুন চালক যুক্ত করুন",
    btn_defaulters_pdf: "ডিফল্টার পিডিএফ",
    chk_only_defaulters: "শুধু বাকিদার",
    pnl_statement_title: "মাসিক লাভ ও ক্ষতি বিবরণী (P&L)",
    btn_pnl_pdf: "লাভ-ক্ষতি পিডিএফ",
    btn_excel_audit: "সম্পূর্ণ অডিট এক্সেল",
    pnl_gross_collections: "মোট রিকশা জমা",
    pnl_total_expenses: "মোট খরচ (ভাড়া + মেরামত)",
    pnl_net_profit: "মালিকের প্রকৃত লাভ",
    pnl_cat_distribution: "ক্যাটাগরিভিত্তিক ব্যয়ের বিন্যাস",
    gps_title: "জিপিএস ফ্লিট ট্র্যাকিং",
    gps_desc: "রিয়েল-টাইম লাইভ লোকেশন, গতি পর্যবেক্ষণ এবং জিও-ফেন্সিং পরবর্তী ফার্মওয়্যারে যুক্ত হবে।",
    modal_qr_title: "কিউআর স্ক্যানার",
    qr_align_text: "ফ্রেমের মধ্যে কিউআর কোড রাখুন",
    qr_quick_presets: "দ্রুত টেস্ট প্রিসেট:",
    lbl_driver: "চালক:",
    lbl_agreed_rate: "চুক্তির জমা:",
    lbl_due: "বর্তমান বাকি:",
    btn_record_deposit: "জমা এন্ট্রি করুন",
    modal_deposit_title: "ভাড়ার জমা রেকর্ড করুন",
    lbl_target: "টার্গেট",
    lbl_remaining_due: "অবশিষ্ট বাকি",
    lbl_select_rickshaw: "রিকশা নির্বাচন করুন",
    lbl_driver_info: "চালকের তথ্য",
    lbl_agreed_joma_rate: "দৈনিক চুক্তির জমা (৳)",
    lbl_amount_deposited: "জমার পরিমাণ (৳)",
    lbl_quick_presets: "কুইক বাটন:",
    lbl_deduct_garage_rent: "দৈনিক গ্যারেজ ভাড়া কর্তন",
    lbl_rent_amount: "গ্যারেজ ভাড়া:",
    btn_save_deposit: "জমা নিশ্চিত করুন",
    modal_expense_title: "খরচ এন্ট্রি করুন",
    lbl_category: "ক্যাটাগরি",
    cat_parts: "পার্টস ও ব্যাটারি",
    cat_mechanic: "মিস্ত্রি লেবার খরচ",
    cat_rent: "গ্যারেজ ভাড়া ও বিদ্যুৎ",
    cat_line_fee: "লাইন / ইউনিয়ন ফি",
    cat_other: "অন্যান্য খরচ",
    lbl_amount: "পরিমাণ (৳)",
    lbl_description: "বিবরণ / কাজের নোট",
    lbl_receipt: "রসিদ / ভাউচার (ঐচ্ছিক)",
    lbl_attach_receipt: "রসিদের ছবি যুক্ত করুন",
    btn_save_expense: "খরচ সেভ করুন",
    modal_add_driver_title: "নতুন চালক নিবন্ধন",
    lbl_full_name: "চালকের পূর্ণ নাম",
    lbl_phone: "মোবাইল নম্বর",
    lbl_agreed_daily_rate: "দৈনিক চুক্তির জমা (৳/দিন)",
    lbl_nid: "জাতীয় পরিচয়পত্র (NID)",
    lbl_address: "বর্তমান ঠিকানা",
    lbl_assign_rickshaw: "রিকশা বরাদ্দ",
    lbl_initial_due: "পূর্বের বকেয়া ব্যালেন্স (৳)",
    btn_register_driver: "চালক যুক্ত করুন",
    modal_edit_driver_title: "ড্রাইভার প্রোফাইল সম্পাদনা",
    btn_update_profile: "প্রোফাইল আপডেট করুন",
    modal_add_rickshaw_title: "নতুন রিকশা যুক্ত করুন",
    lbl_rickshaw_id: "রিকশা আইডি",
    lbl_model_type: "মডেল ও ব্যাটারি টাইপ",
    lbl_standard_rate: "স্ট্যান্ডার্ড ভাড়া রেট (৳/দিন)",
    btn_save_rickshaw: "রিকশা সেভ করুন",
    modal_collect_due_title: "বকেয়া টাকা জমা নিন",
    lbl_current_due: "বর্তমান বকেয়া:",
    lbl_payment_amount: "পরিশোধিত টাকা (৳)",
    btn_confirm_payment: "পেমেন্ট সম্পন্ন করুন",
    modal_sms_title: "বকেয়ার এসএমএস রিমাইন্ডার",
    lbl_recipient: "প্রাপক:",
    btn_cancel: "বাতিল",
    btn_send_now: "এসএমএস পাঠান",
  }
};

// --- Storage Helpers ---
function loadFromStorage(key, fallback) {
  try {
    const saved = localStorage.getItem('project_3_wheel_' + key);
    return saved !== null ? JSON.parse(saved) : fallback;
  } catch (e) {
    return fallback;
  }
}

function saveToStorage(key, data) {
  try {
    localStorage.setItem('project_3_wheel_' + key, JSON.stringify(data));
  } catch (e) {}
}

// --- App State ---
let state = {
  lang: loadFromStorage('lang', 'en'),
  currentUser: loadFromStorage('user_profile', defaultUserProfile),
  isOnline: true,
  selectedAuthRole: 'owner',
  selectedDateFilter: todayIso,
  calYear: new Date().getFullYear(),
  calMonth: new Date().getMonth(),
  rickshaws: loadFromStorage('rickshaws', defaultRickshaws),
  drivers: loadFromStorage('drivers', defaultDrivers),
  collections: loadFromStorage('collections', defaultCollections),
  expenses: loadFromStorage('expenses', defaultExpenses),
  currentSmsTarget: null,
  currentQuickCollectDriver: null,
  activeExpenseCat: 'parts',
  scannedRickshaw: null,
};

// --- Initialization ---
document.addEventListener('DOMContentLoaded', () => {
  applyLanguage(state.lang);
  checkAuthSession();

  document.addEventListener('click', (e) => {
    if (!e.target.closest('.date-picker-wrapper')) {
      const modal = document.getElementById('customCalendarModal');
      if (modal) modal.classList.remove('open');
    }
  });

  renderAll();
});

// --- Authentication Engine ---
function checkAuthSession() {
  const authOverlay = document.getElementById('authOverlay');
  if (!authOverlay) return;

  if (state.currentUser && state.currentUser.isAuthenticated) {
    authOverlay.classList.add('hidden');
    updateUserProfileDisplay();
  } else {
    authOverlay.classList.remove('hidden');
  }
}

function selectAuthRole(role) {
  state.selectedAuthRole = role;
  document.getElementById('authRoleOwner')?.classList.toggle('active', role === 'owner');
  document.getElementById('authRoleManager')?.classList.toggle('active', role === 'manager');

  const idInput = document.getElementById('authIdentifier');
  if (idInput && !idInput.value) {
    idInput.value = role === 'owner' ? 'owner@project3wheel.com' : 'manager@project3wheel.com';
    document.getElementById('authPassword').value = 'admin123';
  }
}

function submitLogin(e) {
  e.preventDefault();
  const idVal = document.getElementById('authIdentifier').value.trim();
  const passVal = document.getElementById('authPassword').value.trim();

  if (!idVal || !passVal) {
    alert('Please enter credentials');
    return;
  }

  // Set logged in profile
  const role = state.selectedAuthRole || 'owner';
  state.currentUser = {
    name: role === 'owner' ? (state.currentUser.name || 'Habib Rahman') : 'Selim Mia',
    garageName: state.currentUser.garageName || 'Habib Electric Garage',
    phone: state.currentUser.phone || (role === 'owner' ? '01711223344' : '01812345678'),
    email: idVal.includes('@') ? idVal : `${idVal}@project3wheel.com`,
    role: role,
    isAuthenticated: true
  };

  saveToStorage('user_profile', state.currentUser);
  checkAuthSession();
  renderAll();
  showToast(state.lang === 'bn' ? `স্বাগতম, ${state.currentUser.name}!` : `Welcome back, ${state.currentUser.name}!`, 'emerald');
}

function logoutUser() {
  if (!confirm(state.lang === 'bn' ? 'আপনি কি নিশ্চিত যে লগআউট করতে চান?' : 'Are you sure you want to log out?')) return;
  state.currentUser.isAuthenticated = false;
  saveToStorage('user_profile', state.currentUser);
  checkAuthSession();
  showToast(state.lang === 'bn' ? 'সফলভাবে লগআউট হয়েছেন' : 'Logged out successfully', 'amber');
}

// --- Profile Management & Edit Engine ---
function openUserProfileModal() {
  document.getElementById('profileFullName').value = state.currentUser.name || 'Habib Rahman';
  document.getElementById('profileGarageName').value = state.currentUser.garageName || 'Habib Electric Garage';
  document.getElementById('profilePhone').value = state.currentUser.phone || '01711223344';
  document.getElementById('profileEmail').value = state.currentUser.email || 'owner@project3wheel.com';
  document.getElementById('profileRole').value = state.currentUser.role || 'owner';
  document.getElementById('profileAvatarLarge').textContent = (state.currentUser.name || 'H')[0].toUpperCase();

  openModal('userProfileModal');
}

function saveUserProfile(e) {
  e.preventDefault();
  state.currentUser.name = document.getElementById('profileFullName').value.trim();
  state.currentUser.garageName = document.getElementById('profileGarageName').value.trim();
  state.currentUser.phone = document.getElementById('profilePhone').value.trim();
  state.currentUser.email = document.getElementById('profileEmail').value.trim();
  state.currentUser.role = document.getElementById('profileRole').value;

  saveToStorage('user_profile', state.currentUser);
  closeModal('userProfileModal');
  updateUserProfileDisplay();
  renderAll();
  showToast(state.lang === 'bn' ? 'প্রোফাইল সফলভাবে আপডেট হয়েছে!' : 'Profile updated successfully!', 'emerald');
}

function updateUserProfileDisplay() {
  const name = state.currentUser.name || 'Habib Rahman';
  const role = state.currentUser.role || 'owner';

  document.getElementById('userName').textContent = name;
  document.getElementById('userAvatar').textContent = name[0].toUpperCase();
  const roleBadge = document.getElementById('userRoleBadge');
  if (roleBadge) {
    roleBadge.textContent = role.toUpperCase();
    roleBadge.className = `badge-pill ${role === 'owner' ? 'badge-blue' : 'badge-amber'}`;
  }

  const roleSwitchText = document.getElementById('roleSwitchText');
  if (roleSwitchText) {
    roleSwitchText.textContent = role === 'owner' 
      ? (state.lang === 'bn' ? 'ম্যানেজার ভিউ' : 'Switch to Manager')
      : (state.lang === 'bn' ? 'মালিক ভিউ' : 'Switch to Owner');
  }
}

function renderAll() {
  saveToStorage('rickshaws', state.rickshaws);
  saveToStorage('drivers', state.drivers);
  saveToStorage('collections', state.collections);
  saveToStorage('expenses', state.expenses);

  updateUserProfileDisplay();
  updateDateTriggerLabel();
  renderCustomCalendarGrid();
  updateMetrics();
  renderVelocityChart();
  renderFleetStatus();
  renderTodayJomaTracker();
  renderCollectionsTable();
  renderExpensesTable();
  renderDriversGrid();
  renderPnlReports();
  populateFormRickshaws();
  populateDriverRickshaws('newDriverRickshaw');
  populateDriverRickshaws('editDriverRickshaw');
}

// --- Bilingual Language Switcher ---
function toggleLanguage() {
  state.lang = state.lang === 'en' ? 'bn' : 'en';
  saveToStorage('lang', state.lang);
  applyLanguage(state.lang);
  renderAll();
  showToast(state.lang === 'en' ? 'Language: English' : 'ভাষা: বাংলা', 'emerald');
}

function applyLanguage(lang) {
  document.body.className = `lang-${lang}`;
  const dict = i18n[lang] || i18n.en;

  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.getAttribute('data-i18n');
    if (dict[key]) {
      el.textContent = dict[key];
    }
  });

  const langLabel = document.getElementById('langLabel');
  if (langLabel) {
    langLabel.textContent = lang === 'en' ? 'EN / বাংলা' : 'বাংলা / EN';
  }
}

// --- Formatters ---
function formatBDT(amount) {
  if (state.lang === 'bn') {
    const digits = { '0': '০', '1': '১', '2': '২', '3': '৩', '4': '৪', '5': '৫', '6': '৬', '7': '৭', '8': '৮', '9': '৯' };
    const str = '৳' + Number(amount || 0).toLocaleString('en-IN');
    return str.split('').map(c => digits[c] || c).join('');
  }
  return '৳' + Number(amount || 0).toLocaleString('en-IN');
}

function formatDateDisplay(isoDateStr) {
  if (!isoDateStr || isoDateStr === 'all') return state.lang === 'bn' ? 'সর্বমোট' : 'All Time';
  const d = new Date(isoDateStr);
  if (isNaN(d.getTime())) return isoDateStr;
  const options = { day: '2-digit', month: 'short', year: 'numeric' };
  return d.toLocaleDateString(state.lang === 'bn' ? 'bn-BD' : 'en-GB', options);
}

// --- 100% In-Theme Liquid Glass Calendar Engine ---
function toggleCustomCalendar() {
  const modal = document.getElementById('customCalendarModal');
  if (modal) modal.classList.toggle('open');
}

function pickCalPreset(preset) {
  document.querySelectorAll('.btn-cal-preset').forEach(b => b.classList.remove('active'));

  if (preset === 'today') {
    state.selectedDateFilter = todayIso;
    document.getElementById('btnCalToday')?.classList.add('active');
  } else if (preset === 'yesterday') {
    const y = new Date();
    y.setDate(y.getDate() - 1);
    state.selectedDateFilter = y.toISOString().split('T')[0];
    document.getElementById('btnCalYest')?.classList.add('active');
  } else if (preset === 'all') {
    state.selectedDateFilter = 'all';
    document.getElementById('btnCalAll')?.classList.add('active');
  }

  const modal = document.getElementById('customCalendarModal');
  if (modal) modal.classList.remove('open');

  renderAll();
  showToast(state.lang === 'bn' ? `তারিখ: ${document.getElementById('selectedDateLabel').textContent}` : `Filtered for ${document.getElementById('selectedDateLabel').textContent}`, 'emerald');
}

function changeCalMonth(offset) {
  state.calMonth += offset;
  if (state.calMonth > 11) {
    state.calMonth = 0;
    state.calYear += 1;
  } else if (state.calMonth < 0) {
    state.calMonth = 11;
    state.calYear -= 1;
  }
  renderCustomCalendarGrid();
}

function renderCustomCalendarGrid() {
  const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  const monthsBn = ['জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন', 'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'];

  const title = document.getElementById('calMonthTitle');
  if (title) {
    title.textContent = state.lang === 'bn' 
      ? `${monthsBn[state.calMonth]} ${state.calYear}`
      : `${months[state.calMonth]} ${state.calYear}`;
  }

  const firstDayIndex = new Date(state.calYear, state.calMonth, 1).getDay();
  const daysInMonth = new Date(state.calYear, state.calMonth + 1, 0).getDate();

  const grid = document.getElementById('calDayGrid');
  if (!grid) return;

  let html = '';
  for (let i = 0; i < firstDayIndex; i++) {
    html += '<div class="cal-day empty"></div>';
  }

  for (let d = 1; d <= daysInMonth; d++) {
    const mm = String(state.calMonth + 1).padStart(2, '0');
    const dd = String(d).padStart(2, '0');
    const fullDate = `${state.calYear}-${mm}-${dd}`;

    const isToday = fullDate === todayIso;
    const isSelected = fullDate === state.selectedDateFilter;

    html += `
      <div class="cal-day ${isToday ? 'today' : ''} ${isSelected ? 'selected' : ''}" onclick="selectCalDate('${fullDate}')">
        ${d}
      </div>
    `;
  }

  grid.innerHTML = html;
}

function selectCalDate(dateStr) {
  state.selectedDateFilter = dateStr;
  document.querySelectorAll('.btn-cal-preset').forEach(b => b.classList.remove('active'));

  const modal = document.getElementById('customCalendarModal');
  if (modal) modal.classList.remove('open');

  renderAll();
  showToast(state.lang === 'bn' ? `তারিখ: ${formatDateDisplay(dateStr)}` : `Filtered for ${formatDateDisplay(dateStr)}`, 'emerald');
}

function updateDateTriggerLabel() {
  const label = document.getElementById('selectedDateLabel');
  if (!label) return;

  if (state.selectedDateFilter === 'all') {
    label.textContent = state.lang === 'bn' ? 'সর্বমোট হিসাব' : 'All Time';
  } else if (state.selectedDateFilter === todayIso) {
    label.textContent = state.lang === 'bn' ? `আজ (${formatDateDisplay(todayIso)})` : `Today (${formatDateDisplay(todayIso)})`;
  } else {
    label.textContent = formatDateDisplay(state.selectedDateFilter);
  }
}

// --- Metrics Calculation Engine ---
function updateMetrics() {
  const filter = state.selectedDateFilter;

  const filteredCollections = filter === 'all'
    ? state.collections
    : state.collections.filter(c => c.date === filter || (filter === todayIso && c.date === 'Today'));

  const filteredExpenses = filter === 'all'
    ? state.expenses
    : state.expenses.filter(e => e.date === filter || (filter === todayIso && e.date === 'Today'));

  // 1. Gross Rickshaw Rental Collections
  const totalRev = filteredCollections.reduce((sum, c) => sum + Number(c.paid || 0), 0);

  // 2. Garage Rent Expenses
  const garageRentExp = filteredExpenses
    .filter(e => e.category === 'rent')
    .reduce((sum, e) => sum + Number(e.amount || 0), 0);

  // 3. Other Expenses
  const otherExp = filteredExpenses
    .filter(e => e.category !== 'rent')
    .reduce((sum, e) => sum + Number(e.amount || 0), 0);

  // 4. Net Profit = Joma - Garage Rent - Other Expenses
  const netProfit = totalRev - (garageRentExp + otherExp);

  // 5. Cumulative Dues
  const totalDues = state.drivers.reduce((sum, d) => sum + Number(d.due || 0), 0);
  const defaulterCount = state.drivers.filter(d => d.due > 0).length;

  const targetRev = filteredCollections.reduce((sum, c) => sum + Number(c.expected || 0), 0);
  const collectionRate = targetRev > 0 ? Math.round((totalRev / targetRev) * 100) : 0;

  document.getElementById('metricTodayRev').textContent = formatBDT(totalRev);
  document.getElementById('metricGarageRent').textContent = formatBDT(garageRentExp);
  document.getElementById('metricOtherExp').textContent = formatBDT(otherExp);
  document.getElementById('metricTodayNet').textContent = formatBDT(netProfit);
  document.getElementById('metricTotalDues').textContent = formatBDT(totalDues);

  document.getElementById('metricDepositCount').textContent = `${filteredCollections.length} ${state.lang === 'bn' ? 'টি জমা' : 'deposits'}`;
  document.getElementById('metricGarageCount').textContent = `${filteredCollections.length} ${state.lang === 'bn' ? 'টি রিকশা' : 'vehicles'}`;
  document.getElementById('metricExpCount').textContent = `${filteredExpenses.length} ${state.lang === 'bn' ? 'টি খরচ' : 'logs'}`;
  document.getElementById('metricCollectionRate').textContent = `${collectionRate}%`;
  document.getElementById('metricDefaulterCount').textContent = defaulterCount;

  const trendNet = document.getElementById('trendNetPill');
  if (netProfit >= 0) {
    trendNet.className = 'trend-pill trend-up';
    trendNet.innerHTML = `<i class="fa-solid fa-arrow-trend-up"></i> ${state.lang === 'bn' ? 'উদ্বৃত্ত লাভ' : 'Net Surplus'}`;
  } else {
    trendNet.className = 'trend-pill trend-down';
    trendNet.innerHTML = `<i class="fa-solid fa-arrow-trend-down"></i> ${state.lang === 'bn' ? 'ঘাটতি' : 'Deficit'}`;
  }
}

// --- Dynamic 7-Day Velocity Chart ---
function renderVelocityChart() {
  const days = state.lang === 'bn'
    ? ['সোম', 'মঙ্গল', 'বুধ', 'বৃহঃ', 'শুক্র', 'শনি', 'রবি']
    : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  const totalRev = state.collections.reduce((sum, c) => sum + Number(c.paid || 0), 0);
  const totalExp = state.expenses.reduce((sum, e) => sum + Number(e.amount || 0), 0);

  const baseRev = Math.max(10, Math.min(100, Math.round(totalRev / 35)));
  const baseExp = Math.max(10, Math.min(100, Math.round(totalExp / 40)));

  const revFactors = [0.7, 0.85, 0.75, 0.95, 0.9, 1.0, 0.65];
  const expFactors = [0.35, 0.25, 0.45, 0.35, 0.55, 0.2, 0.15];

  const container = document.getElementById('velocityBars');
  container.innerHTML = days.map((day, i) => {
    const revH = totalRev > 0 ? Math.min(100, Math.round(baseRev * revFactors[i])) : 8;
    const expH = totalExp > 0 ? Math.min(100, Math.round(baseExp * expFactors[i])) : 5;

    return `
      <div class="bar-column">
        <div class="bars-pair">
          <div class="bar-rev" style="height: ${revH}%" title="Collections: ${formatBDT(revH * 40)}"></div>
          <div class="bar-exp" style="height: ${expH}%" title="Expenses: ${formatBDT(expH * 30)}"></div>
        </div>
        <span class="bar-label ${i === 5 ? 'active' : ''}">${day}</span>
      </div>
    `;
  }).join('');
}

// --- Fleet Health Status ---
function renderFleetStatus() {
  const total = state.rickshaws.length;
  const active = state.rickshaws.filter(r => r.status === 'active').length;
  const maint = state.rickshaws.filter(r => r.status === 'maintenance').length;
  const totalDrivers = state.drivers.length;

  document.getElementById('statTotalFleet').textContent = `${total} ${state.lang === 'bn' ? 'টি' : 'Vehicles'}`;
  document.getElementById('statActiveFleet').textContent = `${active} ${state.lang === 'bn' ? 'সচল' : 'Active'}`;
  document.getElementById('statMaintFleet').textContent = `${maint} ${state.lang === 'bn' ? 'মেরামতে' : 'In Repair'}`;
  document.getElementById('statTotalDrivers').textContent = `${totalDrivers} ${state.lang === 'bn' ? 'জন' : 'Drivers'}`;
}

// --- TODAY'S DRIVER COLLECTION TRACKER WITH CLEAN VECTOR STATUS SELECT ---
function renderTodayJomaTracker() {
  const tbody = document.getElementById('todayJomaTableBody');
  if (!tbody) return;

  const targetDate = state.selectedDateFilter === 'all' ? todayIso : state.selectedDateFilter;

  if (state.drivers.length === 0) {
    tbody.innerHTML = `<tr><td colspan="7" style="text-align: center; color: var(--text-tertiary); padding: 24px;">${state.lang === 'bn' ? 'কোনো চালক নিবন্ধিত নেই।' : 'No drivers registered yet.'}</td></tr>`;
    return;
  }

  const rows = state.drivers.map(driver => {
    const rickshaw = state.rickshaws.find(r => r.id === driver.activeRickshaw) || { id: driver.activeRickshaw || 'Unassigned', rate: driver.agreedDailyRate || 350 };
    const agreedRate = driver.agreedDailyRate || rickshaw.rate || 350;

    const existingCol = state.collections.find(c => c.driverId === driver.id && (c.date === targetDate || (targetDate === todayIso && c.date === 'Today')));

    let currentStatus = existingCol ? existingCol.status : 'unpaid';
    let paidAmount = existingCol ? existingCol.paid : 0;
    let dueAmount = existingCol ? existingCol.due : (existingCol ? 0 : agreedRate);

    return `
      <tr>
        <td>
          <div style="display: flex; align-items: center; gap: 8px;">
            <span class="status-indicator-dot dot-${currentStatus}"></span>
            <div class="avatar" style="width: 28px; height: 28px; font-size: 11px; background: ${currentStatus === 'paid' ? 'rgba(16, 185, 129, 0.2)' : 'rgba(255, 59, 48, 0.2)'}; color: ${currentStatus === 'paid' ? 'var(--emerald-light)' : 'var(--crimson-light)'};">
              ${driver.name[0]}
            </div>
            <div>
              <strong>${driver.name}</strong>
              <div style="font-size: 10px; color: var(--text-tertiary);">${driver.phone}</div>
            </div>
          </div>
        </td>
        <td><span class="badge-pill badge-blue">${driver.activeRickshaw || 'None'}</span></td>
        <td><strong>${formatBDT(agreedRate)}</strong></td>
        <td>
          <select class="status-dropdown-select status-${currentStatus}" onchange="onTodayStatusChange('${driver.id}', this.value)">
            <option value="paid" ${currentStatus === 'paid' ? 'selected' : ''}>${state.lang === 'bn' ? 'পরিশোধিত' : 'Paid (Full)'}</option>
            <option value="due" ${currentStatus === 'due' ? 'selected' : ''}>${state.lang === 'bn' ? 'আংশিক জমা' : 'Partial Due'}</option>
            <option value="unpaid" ${currentStatus === 'unpaid' ? 'selected' : ''}>${state.lang === 'bn' ? 'বাকি' : 'Unpaid'}</option>
            <option value="off" ${currentStatus === 'off' ? 'selected' : ''}>${state.lang === 'bn' ? 'ছুটি' : 'Off Day'}</option>
          </select>
        </td>
        <td><strong class="${paidAmount > 0 ? 'text-emerald' : 'text-secondary'}">${formatBDT(paidAmount)}</strong></td>
        <td><strong class="${dueAmount > 0 ? 'text-crimson' : 'text-emerald'}">${formatBDT(dueAmount)}</strong></td>
        <td style="text-align: right;">
          <div style="display: flex; justify-content: flex-end; gap: 6px;">
            <button class="btn-glass btn-emerald btn-sm" onclick="openDepositForRickshaw('${driver.activeRickshaw || 'R-01'}')" title="Manual Deposit Entry">
              <i class="fa-solid fa-hand-holding-dollar"></i>
            </button>
            <button class="btn-glass btn-amber btn-sm" onclick="openSmsModal('${driver.id}')" title="Send SMS Reminder">
              <i class="fa-solid fa-message"></i>
            </button>
          </div>
        </td>
      </tr>
    `;
  });

  tbody.innerHTML = rows.join('');
}

// --- Interactive Status Change Handler (Direct Real-time Recalculation) ---
function onTodayStatusChange(driverId, newStatus) {
  const driver = state.drivers.find(d => d.id === driverId);
  if (!driver) return;

  const targetDate = state.selectedDateFilter === 'all' ? todayIso : state.selectedDateFilter;
  const agreedRate = driver.agreedDailyRate || 350;

  let existingIndex = state.collections.findIndex(c => c.driverId === driverId && (c.date === targetDate || (targetDate === todayIso && c.date === 'Today')));

  if (newStatus === 'paid') {
    const paid = agreedRate;
    const due = 0;

    if (existingIndex >= 0) {
      state.collections[existingIndex].paid = paid;
      state.collections[existingIndex].due = due;
      state.collections[existingIndex].status = 'paid';
    } else {
      state.collections.unshift({
        id: `COL-${Date.now()}`,
        time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
        date: targetDate,
        rickshawId: driver.activeRickshaw || 'R-01',
        driverId: driver.id,
        driverName: driver.name,
        expected: agreedRate,
        paid: paid,
        due: due,
        garageRent: 100,
        status: 'paid',
        recordedBy: state.currentUser.name || 'Owner',
      });
    }
    showToast(state.lang === 'bn' ? `${driver.name}-এর জমা ৳${paid} পরিশোধিত করা হয়েছে` : `Marked ৳${paid} fully paid for ${driver.name}`, 'emerald');

  } else if (newStatus === 'due') {
    const paid = Math.round(agreedRate / 2);
    const due = agreedRate - paid;

    if (existingIndex >= 0) {
      state.collections[existingIndex].paid = paid;
      state.collections[existingIndex].due = due;
      state.collections[existingIndex].status = 'due';
    } else {
      state.collections.unshift({
        id: `COL-${Date.now()}`,
        time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
        date: targetDate,
        rickshawId: driver.activeRickshaw || 'R-01',
        driverId: driver.id,
        driverName: driver.name,
        expected: agreedRate,
        paid: paid,
        due: due,
        garageRent: 100,
        status: 'due',
        recordedBy: state.currentUser.name || 'Owner',
      });
    }
    showToast(state.lang === 'bn' ? `${driver.name}-এর আংশিক জমা ৳${paid} (বাকি ৳${due})` : `Recorded partial deposit ৳${paid} for ${driver.name}`, 'amber');

  } else if (newStatus === 'unpaid') {
    const paid = 0;
    const due = agreedRate;

    if (existingIndex >= 0) {
      state.collections[existingIndex].paid = paid;
      state.collections[existingIndex].due = due;
      state.collections[existingIndex].status = 'unpaid';
    } else {
      state.collections.unshift({
        id: `COL-${Date.now()}`,
        time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
        date: targetDate,
        rickshawId: driver.activeRickshaw || 'R-01',
        driverId: driver.id,
        driverName: driver.name,
        expected: agreedRate,
        paid: paid,
        due: due,
        garageRent: 100,
        status: 'unpaid',
        recordedBy: state.currentUser.name || 'Owner',
      });
    }
    showToast(state.lang === 'bn' ? `${driver.name}-এর জমা বাকি হিসেবে চিহ্নিত` : `Marked unpaid (due ৳${due}) for ${driver.name}`, 'crimson');

  } else if (newStatus === 'off') {
    if (existingIndex >= 0) {
      state.collections.splice(existingIndex, 1);
    }
    showToast(state.lang === 'bn' ? `${driver.name} আজকের জন্য ছুটিতে রয়েছেন` : `${driver.name} marked on off day`, 'emerald');
  }

  renderAll();
}

// --- Collections Ledger Table ---
function renderCollectionsTable() {
  const query = (document.getElementById('collectionSearch')?.value || '').toLowerCase();
  const filter = document.getElementById('collectionStatusFilter')?.value || 'all';
  const dateFilter = state.selectedDateFilter;

  const filtered = state.collections.filter(c => {
    const matchDate = dateFilter === 'all' || c.date === dateFilter || (dateFilter === todayIso && c.date === 'Today');
    const matchQuery = c.driverName.toLowerCase().includes(query) || c.rickshawId.toLowerCase().includes(query);
    const matchStatus = filter === 'all' || c.status === filter;
    return matchDate && matchQuery && matchStatus;
  });

  const tbody = document.getElementById('collectionsTableBody');
  if (!tbody) return;

  if (filtered.length === 0) {
    tbody.innerHTML = `<tr><td colspan="10" style="text-align: center; color: var(--text-tertiary); padding: 24px;">${state.lang === 'bn' ? 'কোনো জমার রেকর্ড নেই।' : 'No collection logs yet.'}</td></tr>`;
    return;
  }

  tbody.innerHTML = filtered.map(c => `
    <tr>
      <td>${c.date} • ${c.time || ''}</td>
      <td><span class="badge-pill badge-blue">${c.rickshawId}</span></td>
      <td><strong>${c.driverName}</strong></td>
      <td>${formatBDT(c.expected)}</td>
      <td><strong class="text-emerald">${formatBDT(c.paid)}</strong></td>
      <td>${formatBDT(c.due)}</td>
      <td><span class="garage-rent-badge">${formatBDT(c.garageRent || 100)}</span></td>
      <td>
        <span class="badge-pill ${c.status === 'paid' ? 'badge-emerald' : (c.status === 'due' ? 'badge-amber' : 'badge-crimson')}">
          ${c.status.toUpperCase()}
        </span>
      </td>
      <td><small style="color: var(--text-tertiary);">${c.recordedBy}</small></td>
      <td style="text-align: right;">
        <button class="btn-glass btn-sm" style="color: var(--crimson-light); padding: 4px 8px;" onclick="deleteCollection('${c.id}')" title="Delete record">
          <i class="fa-solid fa-trash-can"></i>
        </button>
      </td>
    </tr>
  `).join('');
}

// --- Expenses Table ---
function renderExpensesTable() {
  const dateFilter = state.selectedDateFilter;
  const filtered = state.expenses.filter(e => {
    return dateFilter === 'all' || e.date === dateFilter || (dateFilter === todayIso && e.date === 'Today');
  });

  const tbody = document.getElementById('expensesTableBody');
  if (!tbody) return;

  if (filtered.length === 0) {
    tbody.innerHTML = `<tr><td colspan="6" style="text-align: center; color: var(--text-tertiary); padding: 24px;">${state.lang === 'bn' ? 'কোনো খরচের হিসাব নেই।' : 'No expense records logged yet.'}</td></tr>`;
    return;
  }

  tbody.innerHTML = filtered.map(e => `
    <tr>
      <td>${e.date}</td>
      <td><span class="badge-pill ${e.category === 'rent' ? 'badge-amber' : 'badge-crimson'}">${e.catName}</span></td>
      <td><strong class="text-crimson">${formatBDT(e.amount)}</strong></td>
      <td>${e.note}</td>
      <td><small style="color: var(--text-tertiary);">${e.recordedBy}</small></td>
      <td style="text-align: right;">
        <button class="btn-glass btn-sm" style="color: var(--crimson-light); padding: 4px 8px;" onclick="deleteExpense('${e.id}')" title="Delete expense">
          <i class="fa-solid fa-trash-can"></i>
        </button>
      </td>
    </tr>
  `).join('');
}

// --- DRIVER DIRECTORY (Company Teammates Style UI) ---
function renderDriversGrid() {
  const query = (document.getElementById('driverSearch')?.value || '').toLowerCase();
  const onlyDefaulters = document.getElementById('onlyDefaultersCheckbox')?.checked || false;

  const filtered = state.drivers.filter(d => {
    const matchQuery = d.name.toLowerCase().includes(query) || d.phone.includes(query) || d.nid.includes(query);
    const matchDefaulter = !onlyDefaulters || d.due > 0;
    return matchQuery && matchDefaulter;
  });

  const grid = document.getElementById('driversGrid');
  if (!grid) return;

  if (filtered.length === 0) {
    grid.innerHTML = `<div style="grid-column: 1/-1; text-align: center; color: var(--text-tertiary); padding: 32px;">${state.lang === 'bn' ? 'কোনো চালক পাওয়া যায়নি।' : 'No matching drivers in directory.'}</div>`;
    return;
  }

  grid.innerHTML = filtered.map(d => `
    <div class="teammate-card">
      <div class="teammate-top">
        <div class="teammate-identity">
          <div class="teammate-avatar ${d.due > 0 ? 'has-due' : ''}">
            ${d.name[0]}
          </div>
          <div class="teammate-names">
            <h4>${d.name}</h4>
            <span><i class="fa-solid fa-phone" style="font-size: 10px; margin-right: 4px;"></i>${d.phone}</span>
          </div>
        </div>
        <span class="badge-pill ${d.due > 0 ? 'badge-amber' : 'badge-emerald'}">
          ${d.due > 0 ? (state.lang === 'bn' ? 'বকেয়া' : 'DUE') : (state.lang === 'bn' ? 'সচল' : 'ACTIVE')}
        </span>
      </div>

      <div class="teammate-details-grid">
        <div class="teammate-detail-item">
          <span>${state.lang === 'bn' ? 'নির্ধারিত রিকশা' : 'Assigned Rickshaw'}</span>
          <strong>${d.activeRickshaw || (state.lang === 'bn' ? 'নেই' : 'Unassigned')}</strong>
        </div>
        <div class="teammate-detail-item">
          <span>${state.lang === 'bn' ? 'দৈনিক চুক্তি' : 'Agreed Daily Joma'}</span>
          <strong class="text-blue">৳${d.agreedDailyRate || 350}/day</strong>
        </div>
        <div class="teammate-detail-item">
          <span>${state.lang === 'bn' ? 'বর্তমান বকেয়া' : 'Pending Due'}</span>
          <strong class="${d.due > 0 ? 'text-crimson' : 'text-emerald'}">${formatBDT(d.due)}</strong>
        </div>
        <div class="teammate-detail-item">
          <span>${state.lang === 'bn' ? 'জাতীয় পরিচয়পত্র' : 'NID'}</span>
          <strong>${d.nid}</strong>
        </div>
      </div>

      <div class="teammate-footer">
        <div style="font-size: 10px; color: var(--text-tertiary);">
          <i class="fa-solid fa-location-dot"></i> ${d.address}
        </div>
        <div class="teammate-actions">
          <button class="btn-glass btn-sm" onclick="openEditDriverModal('${d.id}')" title="Edit Profile">
            <i class="fa-solid fa-user-pen"></i>
          </button>
          ${d.due > 0 ? `
            <button class="btn-glass btn-emerald btn-sm" onclick="openQuickCollectModal('${d.id}')" title="Collect Due">
              <i class="fa-solid fa-coins"></i>
            </button>
            <button class="btn-glass btn-amber btn-sm" onclick="openSmsModal('${d.id}')" title="Send SMS">
              <i class="fa-solid fa-message"></i>
            </button>
          ` : ''}
          <button class="btn-glass btn-sm" style="color: var(--crimson-light);" onclick="deleteDriver('${d.id}')" title="Remove">
            <i class="fa-solid fa-trash"></i>
          </button>
        </div>
      </div>
    </div>
  `).join('');
}

// --- Edit Driver Modal & Submit Engine ---
function openEditDriverModal(driverId) {
  const driver = state.drivers.find(d => d.id === driverId);
  if (!driver) return;

  document.getElementById('editDriverId').value = driver.id;
  document.getElementById('editDriverName').value = driver.name;
  document.getElementById('editDriverPhone').value = driver.phone;
  document.getElementById('editDriverDailyRate').value = driver.agreedDailyRate || 350;
  document.getElementById('editDriverNid').value = driver.nid;
  document.getElementById('editDriverAddress').value = driver.address;
  document.getElementById('editDriverRickshaw').value = driver.activeRickshaw || '';
  document.getElementById('editDriverDue').value = driver.due;

  openModal('editDriverModal');
}

function submitEditDriver(e) {
  e.preventDefault();
  const id = document.getElementById('editDriverId').value;
  const driver = state.drivers.find(d => d.id === id);
  if (!driver) return;

  const prevRickshaw = driver.activeRickshaw;
  const newRickshaw = document.getElementById('editDriverRickshaw').value || null;

  driver.name = document.getElementById('editDriverName').value.trim();
  driver.phone = document.getElementById('editDriverPhone').value.trim();
  driver.agreedDailyRate = Number(document.getElementById('editDriverDailyRate').value || 350);
  driver.nid = document.getElementById('editDriverNid').value.trim();
  driver.address = document.getElementById('editDriverAddress').value.trim();
  driver.activeRickshaw = newRickshaw;
  driver.due = Number(document.getElementById('editDriverDue').value || 0);

  if (prevRickshaw && prevRickshaw !== newRickshaw) {
    const oldR = state.rickshaws.find(r => r.id === prevRickshaw);
    if (oldR) oldR.driverId = null;
  }
  if (newRickshaw) {
    const r = state.rickshaws.find(r => r.id === newRickshaw);
    if (r) {
      r.driverId = driver.id;
      r.status = 'active';
      r.rate = driver.agreedDailyRate;
    }
  }

  closeModal('editDriverModal');
  renderAll();
  showToast(state.lang === 'bn' ? `${driver.name}-এর প্রোফাইল আপডেট হয়েছে` : `Updated profile for ${driver.name}`, 'emerald');
}

// --- P&L Reports Distribution ---
function renderPnlReports() {
  const totalRev = state.collections.reduce((sum, c) => sum + Number(c.paid || 0), 0);
  const totalExp = state.expenses.reduce((sum, e) => sum + Number(e.amount || 0), 0);
  const netProfit = totalRev - totalExp;

  document.getElementById('pnlTotalRev').textContent = formatBDT(totalRev);
  document.getElementById('pnlTotalExp').textContent = formatBDT(totalExp);
  document.getElementById('pnlNetProfit').textContent = formatBDT(netProfit);

  const catTotals = {};
  state.expenses.forEach(e => {
    catTotals[e.catName] = (catTotals[e.catName] || 0) + Number(e.amount || 0);
  });

  const catBars = document.getElementById('expenseCategoryBars');
  catBars.innerHTML = Object.entries(catTotals).map(([name, amt]) => {
    const pct = totalExp > 0 ? Math.round((amt / totalExp) * 100) : 0;
    return `
      <div class="cat-progress-row">
        <div class="cat-progress-header">
          <span>${name}</span>
          <strong>${formatBDT(amt)} (${pct}%)</strong>
        </div>
        <div class="progress-track">
          <div class="progress-fill" style="width: ${pct}%; background: var(--grad-crimson);"></div>
        </div>
      </div>
    `;
  }).join('');
}

// --- Add New Driver ---
function populateDriverRickshaws(selectId) {
  const select = document.getElementById(selectId);
  if (!select) return;
  select.innerHTML = '<option value="">-- No Rickshaw Assigned --</option>' + state.rickshaws.map(r => `
    <option value="${r.id}">${r.id} - ${r.model}</option>
  `).join('');
}

function submitNewDriver(e) {
  e.preventDefault();
  const name = document.getElementById('newDriverName').value.trim();
  const phone = document.getElementById('newDriverPhone').value.trim();
  const agreedRate = Number(document.getElementById('newDriverDailyRate').value || 350);
  const nid = document.getElementById('newDriverNid').value.trim();
  const address = document.getElementById('newDriverAddress').value.trim();
  const rickshawId = document.getElementById('newDriverRickshaw').value;
  const initialDue = Number(document.getElementById('newDriverInitialDue').value || 0);

  const newDriver = {
    id: `D-${Date.now().toString().slice(-4)}`,
    name: name,
    phone: phone,
    agreedDailyRate: agreedRate,
    nid: nid,
    due: initialDue,
    activeRickshaw: rickshawId || null,
    address: address,
    joinDate: todayIso,
  };

  if (rickshawId) {
    const r = state.rickshaws.find(elem => elem.id === rickshawId);
    if (r) {
      r.driverId = newDriver.id;
      r.status = 'active';
      r.rate = agreedRate;
    }
  }

  state.drivers.push(newDriver);
  closeModal('addDriverModal');
  document.getElementById('addDriverForm').reset();
  renderAll();
  showToast(state.lang === 'bn' ? `নতুন চালক ${name} নিবন্ধিত হয়েছেন` : `Driver ${name} registered successfully`, 'emerald');
}

// --- Add New Rickshaw ---
function submitNewRickshaw(e) {
  e.preventDefault();
  const id = document.getElementById('newRickshawId').value.trim().toUpperCase();
  const model = document.getElementById('newRickshawModel').value.trim();
  const rate = Number(document.getElementById('newRickshawRate').value || 350);

  if (state.rickshaws.some(r => r.id === id)) {
    alert(`Rickshaw ID ${id} already exists.`);
    return;
  }

  const newR = {
    id: id,
    model: model,
    rate: rate,
    status: 'active',
    driverId: null,
  };

  state.rickshaws.push(newR);
  closeModal('addRickshawModal');
  document.getElementById('addRickshawForm').reset();
  renderAll();
  showToast(state.lang === 'bn' ? `রিকশা ${id} ফ্লিটে যুক্ত হয়েছে` : `Rickshaw ${id} added to fleet`, 'emerald');
}

// --- Delete Functions ---
function deleteCollection(id) {
  const index = state.collections.findIndex(c => c.id === id);
  if (index === -1) return;

  const item = state.collections[index];
  if (!confirm(`Delete collection entry for ${item.driverName}?`)) return;

  const driver = state.drivers.find(d => d.id === item.driverId);
  if (driver && item.due > 0) {
    driver.due = Math.max(0, driver.due - item.due);
  }

  state.collections.splice(index, 1);
  renderAll();
  showToast('Collection record deleted', 'amber');
}

function deleteExpense(id) {
  const index = state.expenses.findIndex(e => e.id === id);
  if (index === -1) return;

  if (!confirm(`Delete expense "${state.expenses[index].note}"?`)) return;

  state.expenses.splice(index, 1);
  renderAll();
  showToast('Expense record removed', 'amber');
}

function deleteDriver(id) {
  const index = state.drivers.findIndex(d => d.id === id);
  if (index === -1) return;

  const item = state.drivers[index];
  if (!confirm(`Remove driver ${item.name} from directory?`)) return;

  if (item.activeRickshaw) {
    const r = state.rickshaws.find(elem => elem.id === item.activeRickshaw);
    if (r) r.driverId = null;
  }

  state.drivers.splice(index, 1);
  renderAll();
  showToast(`Driver ${item.name} removed`, 'crimson');
}

// --- Quick Due Collection ---
function openQuickCollectModal(driverId) {
  const driver = state.drivers.find(d => d.id === driverId);
  if (!driver) return;

  state.currentQuickCollectDriver = driver;
  document.getElementById('quickCollectDriverName').textContent = driver.name;
  document.getElementById('quickCollectCurrentDue').textContent = formatBDT(driver.due);
  document.getElementById('quickCollectAmount').value = driver.due;

  openModal('quickCollectModal');
}

function submitQuickCollection(e) {
  e.preventDefault();
  if (!state.currentQuickCollectDriver) return;

  const driver = state.currentQuickCollectDriver;
  const payAmount = Number(document.getElementById('quickCollectAmount').value || 0);

  if (payAmount <= 0) return;

  driver.due = Math.max(0, driver.due - payAmount);
  const remainingDue = driver.due;

  const newCol = {
    id: `COL-DUE-${Date.now()}`,
    time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
    date: state.selectedDateFilter === 'all' ? todayIso : state.selectedDateFilter,
    rickshawId: driver.activeRickshaw || 'DUE-SETTLE',
    driverId: driver.id,
    driverName: driver.name,
    expected: payAmount,
    paid: payAmount,
    due: remainingDue,
    garageRent: 0,
    status: remainingDue === 0 ? 'paid' : 'due',
    recordedBy: state.currentUser.name || 'Owner',
  };

  state.collections.unshift(newCol);
  closeModal('quickCollectModal');
  renderAll();
  showToast(state.lang === 'bn' ? `${driver.name}-এর থেকে ৳${payAmount} জমা নেওয়া হয়েছে` : `Collected ৳${payAmount} from ${driver.name}`, 'emerald');
}

// --- Form Population & Calculators ---
function populateFormRickshaws() {
  const select = document.getElementById('formRickshawSelect');
  if (!select) return;
  select.innerHTML = state.rickshaws.map(r => `
    <option value="${r.id}">${r.id} - ${r.model} (৳${r.rate}/day)</option>
  `).join('');
  onFormRickshawChange();
}

function onFormRickshawChange() {
  const select = document.getElementById('formRickshawSelect');
  const rickshaw = state.rickshaws.find(r => r.id === select.value);
  if (!rickshaw) return;

  const driver = state.drivers.find(d => d.id === rickshaw.driverId);
  const agreedRate = driver ? (driver.agreedDailyRate || rickshaw.rate) : rickshaw.rate;

  document.getElementById('formDriverName').textContent = driver ? `${driver.name} (৳${agreedRate}/day)` : 'Unassigned';
  const badge = document.getElementById('formDriverDueBadge');
  badge.textContent = `DUE: ${formatBDT(driver ? driver.due : 0)}`;
  badge.className = `badge-pill ${driver && driver.due > 0 ? 'badge-crimson' : 'badge-emerald'}`;

  document.getElementById('formExpectedRate').value = agreedRate;
  document.getElementById('formPaidAmount').value = agreedRate;
  recalcCollection();
}

function setPresetAmount(amt) {
  document.getElementById('formPaidAmount').value = amt;
  recalcCollection();
}

function toggleGarageRentInput() {
  const check = document.getElementById('includeGarageRentCheck');
  const group = document.getElementById('garageRentInputGroup');
  if (group) group.style.display = check?.checked ? 'flex' : 'none';
}

function recalcCollection() {
  const exp = Number(document.getElementById('formExpectedRate').value || 0);
  const paid = Number(document.getElementById('formPaidAmount').value || 0);
  const due = Math.max(0, exp - paid);

  document.getElementById('calcExpected').textContent = formatBDT(exp);
  document.getElementById('calcPaid').textContent = formatBDT(paid);
  document.getElementById('calcDue').textContent = formatBDT(due);
  document.getElementById('calcDue').className = due > 0 ? 'text-crimson' : 'text-secondary';
}

function openDepositForRickshaw(rickshawId) {
  openModal('collectionModal');
  const select = document.getElementById('formRickshawSelect');
  if (select) {
    select.value = rickshawId;
    onFormRickshawChange();
  }
}

function submitCollection(e) {
  e.preventDefault();
  const dateVal = state.selectedDateFilter === 'all' ? todayIso : state.selectedDateFilter;
  const rickshawId = document.getElementById('formRickshawSelect').value;
  const rickshaw = state.rickshaws.find(r => r.id === rickshawId);
  const driver = state.drivers.find(d => d.id === rickshaw?.driverId);

  const exp = Number(document.getElementById('formExpectedRate').value || 350);
  const paid = Number(document.getElementById('formPaidAmount').value || 0);
  const due = Math.max(0, exp - paid);
  const status = due <= 0 ? 'paid' : (paid > 0 ? 'due' : 'unpaid');

  const includeGarageRent = document.getElementById('includeGarageRentCheck')?.checked || false;
  const garageRentAmount = includeGarageRent ? Number(document.getElementById('formGarageRentAmount')?.value || 100) : 0;

  const newRecord = {
    id: `COL-${Date.now()}`,
    time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
    date: dateVal,
    rickshawId: rickshawId,
    driverId: driver ? driver.id : 'D-UNKNOWN',
    driverName: driver ? driver.name : 'Unknown Driver',
    expected: exp,
    paid: paid,
    due: due,
    garageRent: garageRentAmount,
    status: status,
    recordedBy: state.currentUser.name || 'Owner',
  };

  state.collections.unshift(newRecord);

  if (includeGarageRent && garageRentAmount > 0) {
    const rentExp = {
      id: `EXP-RENT-${Date.now()}`,
      date: dateVal,
      category: 'rent',
      catName: 'Garage Rent & Power',
      amount: garageRentAmount,
      note: `Daily garage rent for ${rickshawId} (${driver ? driver.name : 'Unit'})`,
      recordedBy: 'SYSTEM-AUTO',
    };
    state.expenses.unshift(rentExp);
  }

  if (driver) {
    driver.due = Math.max(0, driver.due + due);
  }

  closeModal('collectionModal');
  renderAll();
  showToast(state.lang === 'bn' ? `৳${paid} জমা রেকর্ড করা হয়েছে` : `Deposit of ৳${paid} recorded`, 'emerald');
}

function selectExpenseCat(cat, btn) {
  state.activeExpenseCat = cat;
  document.querySelectorAll('.cat-chip').forEach(el => el.classList.remove('active'));
  btn.classList.add('active');
}

function simulateReceiptAttach() {
  const box = document.querySelector('.receipt-attach-box');
  const icon = document.getElementById('receiptIcon');
  const text = document.getElementById('receiptText');

  box.classList.add('attached');
  icon.className = 'fa-solid fa-circle-check text-emerald';
  text.textContent = 'voucher_8492.jpg';
  showToast('Receipt attached', 'emerald');
}

function submitExpense(e) {
  e.preventDefault();
  const dateVal = state.selectedDateFilter === 'all' ? todayIso : state.selectedDateFilter;
  const amt = Number(document.getElementById('formExpAmount').value || 0);
  const note = document.getElementById('formExpNote').value.trim();

  const catNames = {
    parts: 'Parts & Battery',
    mechanic: 'Mechanic Labor',
    rent: 'Garage Rent & Power',
    line_fee: 'Line / Union Fee',
    other: 'Miscellaneous',
  };

  const newExp = {
    id: `EXP-${Date.now()}`,
    date: dateVal,
    category: state.activeExpenseCat,
    catName: catNames[state.activeExpenseCat] || 'Other',
    amount: amt,
    note: note,
    recordedBy: state.currentUser.name || 'Owner',
  };

  state.expenses.unshift(newExp);
  closeModal('expenseModal');
  document.getElementById('expenseForm').reset();
  renderAll();
  showToast(state.lang === 'bn' ? `৳${amt} খরচ রেকর্ড করা হয়েছে` : `Expense of ৳${amt} recorded`, 'crimson');
}

// --- Navigation & Mobile Drawer ---
function toggleMobileSidebar() {
  const sidebar = document.getElementById('sidebar');
  const overlay = document.getElementById('sidebarOverlay');
  if (sidebar && overlay) {
    sidebar.classList.toggle('drawer-open');
    overlay.classList.toggle('active');
  }
}

function switchTab(tabId) {
  document.querySelectorAll('.nav-item').forEach(el => el.classList.remove('active'));
  document.querySelectorAll('.mobile-nav-item').forEach(el => el.classList.remove('active'));
  document.querySelectorAll('.tab-pane').forEach(el => el.classList.remove('active'));

  const tab = document.getElementById(`tab-${tabId}`);
  if (tab) tab.classList.add('active');

  const sidebar = document.getElementById('sidebar');
  const overlay = document.getElementById('sidebarOverlay');
  if (sidebar) sidebar.classList.remove('drawer-open');
  if (overlay) overlay.classList.remove('active');
}

// --- Role Switcher ---
function toggleRole() {
  const newRole = state.currentUser.role === 'owner' ? 'manager' : 'owner';
  state.currentUser.role = newRole;
  if (newRole === 'manager') {
    state.currentUser.name = 'Selim Mia';
  } else {
    state.currentUser.name = 'Habib Rahman';
  }
  saveToStorage('user_profile', state.currentUser);
  updateUserProfileDisplay();
  renderAll();
  showToast(newRole === 'manager' ? 'Switched to Garage Manager View' : 'Switched to Fleet Owner View', newRole === 'manager' ? 'amber' : 'emerald');
}

// --- Network Sim Toggle ---
function toggleNetworkSim() {
  state.isOnline = !state.isOnline;
  const pill = document.getElementById('syncPill');
  const dot = document.getElementById('syncDot');
  const text = document.getElementById('syncText');

  if (state.isOnline) {
    pill.className = 'sync-status-pill';
    dot.className = 'status-dot online';
    text.textContent = 'Live Firestore';
    showToast('Network online! Synchronized to Firestore.', 'emerald');
  } else {
    pill.className = 'sync-status-pill offline';
    dot.className = 'status-dot offline';
    text.textContent = 'Offline Queue';
    showToast('Offline Mode: Records saved locally in Hive.', 'amber');
  }
}

// --- Modals Management ---
function openModal(id) {
  const modal = document.getElementById(id);
  if (modal) modal.classList.add('open');
}

function closeModal(id) {
  const modal = document.getElementById(id);
  if (modal) modal.classList.remove('open');
}

// --- QR Scanner Simulation ---
function simulateScan(rickshawId) {
  const rickshaw = state.rickshaws.find(r => r.id === rickshawId);
  if (!rickshaw) return;

  state.scannedRickshaw = rickshaw;
  const driver = state.drivers.find(d => d.id === rickshaw.driverId);
  const agreedRate = driver ? (driver.agreedDailyRate || rickshaw.rate) : rickshaw.rate;

  document.getElementById('scannedRickshawTitle').textContent = `Rickshaw ${rickshaw.id}`;
  document.getElementById('scannedRickshawModel').textContent = rickshaw.model;
  document.getElementById('scannedDriverName').textContent = driver ? driver.name : 'Unassigned';
  document.getElementById('scannedDriverAgreedRate').textContent = `৳${agreedRate} / day`;
  document.getElementById('scannedDriverDue').textContent = driver ? formatBDT(driver.due) : '৳0';

  const statusBadge = document.getElementById('scannedStatusBadge');
  if (rickshaw.status === 'active') {
    statusBadge.className = 'badge-pill badge-emerald';
    statusBadge.textContent = 'ACTIVE';
  } else {
    statusBadge.className = 'badge-pill badge-amber';
    statusBadge.textContent = 'MAINTENANCE';
  }

  document.getElementById('scannedResultCard').style.display = 'block';
}

function openDepositFromScan() {
  closeModal('qrModal');
  if (state.scannedRickshaw) {
    document.getElementById('formRickshawSelect').value = state.scannedRickshaw.id;
    onFormRickshawChange();
  }
  openModal('collectionModal');
}

// --- SMS Modal Logic ---
function openSmsModal(driverId) {
  const driver = state.drivers.find(d => d.id === driverId);
  if (!driver) return;

  state.currentSmsTarget = driver;
  document.getElementById('smsRecipient').textContent = `${driver.name} (${driver.phone})`;
  document.getElementById('smsBengaliText').textContent = `শ্রদ্ধেয় ${driver.name} ভাই, প্রজেক্ট ৩ হুইল গ্যারেজে আপনার বকেয়া পাওনা ৳${driver.due} টাকা। অনুগ্রহ করে দ্রুত পরিশোধ করুন। ধন্যবাদ।`;

  openModal('smsModal');
}

function executeSendSms() {
  if (!state.currentSmsTarget) return;
  const driver = state.currentSmsTarget;
  closeModal('smsModal');
  showToast(`SMS dispatched to ${driver.name} via Greenweb API`, 'amber');
}

// --- 1-Click PDF Generation ---
function exportDailyCollectionsPdf() {
  const { jsPDF } = window.jspdf;
  const doc = new jsPDF();

  doc.setFontSize(18);
  doc.setTextColor(10, 132, 255);
  doc.text('PROJECT 3 WHEEL', 14, 20);

  doc.setFontSize(14);
  doc.setTextColor(0, 0, 0);
  doc.text('Daily Fleet Collection Summary', 14, 28);

  const tableData = state.collections.map(c => [
    c.date + ' ' + (c.time || ''),
    c.rickshawId,
    c.driverName,
    'Tk ' + c.expected,
    'Tk ' + c.paid,
    'Tk ' + c.due,
    'Tk ' + (c.garageRent || 100),
    c.status.toUpperCase(),
  ]);

  doc.autoTable({
    startY: 36,
    head: [['Date/Time', 'Rickshaw', 'Driver Name', 'Target', 'Paid', 'Due', 'Garage Rent', 'Status']],
    body: tableData.length > 0 ? tableData : [['-', '-', 'No data recorded yet', '-', '-', '-', '-', '-']],
    theme: 'grid',
    headStyles: { fillColor: [20, 25, 35] },
  });

  doc.save('Project_3_Wheel_Collections.pdf');
  showToast('Collection PDF generated', 'emerald');
}

function exportMonthlyPnlPdf() {
  const { jsPDF } = window.jspdf;
  const doc = new jsPDF();

  doc.setFontSize(18);
  doc.setTextColor(10, 132, 255);
  doc.text('PROJECT 3 WHEEL', 14, 20);

  doc.setFontSize(14);
  doc.setTextColor(0, 0, 0);
  doc.text('Financial Statement (P&L Audit)', 14, 28);

  const totalRev = state.collections.reduce((sum, c) => sum + Number(c.paid || 0), 0);
  const totalExp = state.expenses.reduce((sum, e) => sum + Number(e.amount || 0), 0);
  const netProfit = totalRev - totalExp;

  doc.autoTable({
    startY: 36,
    head: [['Financial Metric Description', 'Amount (BDT)']],
    body: [
      ['Gross Rickshaw Collections', 'Tk ' + totalRev],
      ['Total Operational & Garage Rent Costs', 'Tk ' + totalExp],
      ['Owner\'s Net Surplus', 'Tk ' + netProfit],
    ],
    theme: 'grid',
    headStyles: { fillColor: [20, 25, 35] },
  });

  doc.save('Project_3_Wheel_PNL.pdf');
  showToast('P&L Statement PDF generated', 'primary');
}

// --- 1-Click Excel Generation ---
function exportFullExcel() {
  const wb = XLSX.utils.book_new();

  const collData = state.collections.map(c => ({
    'Date & Time': `${c.date} ${c.time || ''}`,
    'Rickshaw ID': c.rickshawId,
    'Driver Name': c.driverName,
    'Expected Joma': c.expected,
    'Paid Amount': c.paid,
    'Remaining Due': c.due,
    'Garage Rent': c.garageRent || 100,
    'Status': c.status.toUpperCase(),
    'Logged By': c.recordedBy,
  }));
  const wsColl = XLSX.utils.json_to_sheet(collData.length > 0 ? collData : [{ 'Status': 'No logs yet' }]);
  XLSX.utils.book_append_sheet(wb, wsColl, 'Collections');

  const expData = state.expenses.map(e => ({
    'Date': e.date,
    'Category': e.catName,
    'Amount': e.amount,
    'Description': e.note,
    'Logged By': e.recordedBy,
  }));
  const wsExp = XLSX.utils.json_to_sheet(expData.length > 0 ? expData : [{ 'Status': 'No expenses yet' }]);
  XLSX.utils.book_append_sheet(wb, wsExp, 'Expenses');

  const driverData = state.drivers.map(d => ({
    'Driver ID': d.id,
    'Full Name': d.name,
    'Phone': d.phone,
    'Agreed Rate': d.agreedDailyRate || 350,
    'NID': d.nid,
    'Rickshaw': d.activeRickshaw || 'None',
    'Cumulative Due': d.due,
    'Address': d.address,
  }));
  const wsDriver = XLSX.utils.json_to_sheet(driverData);
  XLSX.utils.book_append_sheet(wb, wsDriver, 'Drivers');

  XLSX.writeFile(wb, 'Project_3_Wheel_Audit.xlsx');
  showToast('Excel Workbook exported', 'emerald');
}

// --- Toast Helper ---
function showToast(message, type = 'emerald') {
  const container = document.getElementById('toastContainer');
  const toast = document.createElement('div');
  toast.className = `toast toast-${type}`;
  toast.innerHTML = `<i class="fa-solid fa-circle-check"></i> ${message}`;
  container.appendChild(toast);

  setTimeout(() => {
    toast.style.opacity = '0';
    setTimeout(() => toast.remove(), 300);
  }, 3000);
}
