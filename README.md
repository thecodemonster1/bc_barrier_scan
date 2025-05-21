# BCBarrierScan

## Blockchain Integration Barriers Assessment Tool

BCBarrierScan is a Flutter application designed to help organizations identify and quantify barriers to blockchain integration. This tool evaluates regulatory, technological, and organizational barriers, calculating a weighted assessment of the challenges your organization may face when implementing blockchain technology.

![BCBarrierScan Logo](assets/images/University_of_Moratuwa_logo.png)

## Features

- **Organization Profile**: Record your organization and project details
- **Comprehensive Barrier Assessment**: Analyze three key barrier categories:
  - Regulatory Barriers (74% weight)
  - Technological Barriers (19% weight)
  - Organizational Barriers (8% weight)
- **Detailed Barrier Selection**: Choose from specific, researched barriers within each category
- **Weighted Scoring System**: Calculate impact scores based on barrier significance
- **Visual Reports**: View detailed assessment results with progress indicators
- **Recommendations Engine**: Receive targeted recommendations to overcome identified barriers
- **PDF Export**: Generate and share professional assessment reports

## Installation

1. **Prerequisites**:

   - Flutter SDK (v3.0.0 or newer)
   - Dart SDK
   - Android Studio or VS Code with Flutter extensions

2. **Clone the repository**:

   ```bash
   git clone https://github.com/yourusername/bc_barrier_scan.git
   cd bc_barrier_scan
   ```

3. **Install dependencies**:

   ```bash
   flutter pub get
   ```

4. **Run the application**:
   ```bash
   flutter run
   ```

## Usage

1. **Start Assessment**: Launch the app and click "START ASSESSMENT"
2. **Enter Organization Details**: Provide your organization and project names
3. **Select Barrier Categories**: Navigate through the three main barrier categories
4. **Choose Specific Barriers**: Select barriers that apply to your organization
5. **Generate Report**: Review your assessment results and recommendations
6. **Share or Save**: Export your report as PDF for sharing or future reference

## Technical Details

- **Framework**: Flutter
- **Dependencies**:
  - path_provider: File management for report generation
  - pdf: PDF document creation
  - open_file: Viewing generated reports
  - shared_preferences: Local data storage
- **Asset Management**: Includes images and custom fonts

## Screenshots

- Starting Screen

<img src="Screenshot_1747828913.png" alt="Starting Screen" width="50%">

- Organization Information
  <img src="Screenshot_1747828918.png" alt="Organization Information" width="50%">

- Barrier Selection

<img src="Screenshot_1747828947.png" alt="Barrier Selection" width="50%">
<img src="Screenshot_1747828964.png" alt="Barrier Selection Details" width="50%">

- Detailed Barriers

<img src="Screenshot_1747828956.png" alt="Detailed Barriers" width="50%">

- Assessment Report

<img src="Screenshot_1747828970.png" alt="Assessment Report" width="50%">
<img src="Screenshot_1747828976.png" alt="Assessment Report Details" width="50%">

## Research Background

This tool is based on research conducted at the University of Moratuwa, Department of Building Economics. The barrier weightings have been determined through academic research to provide an accurate assessment of blockchain integration challenges.

## Developer

Developed by @theCodeMonster1

Developed for Rishfath M.R.M

Department of Building Economics

University of Moratuwa

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- University of Moratuwa for supporting this research
- All contributors to this blockchain assessment tool
- Flutter and Dart teams for providing the development framework
