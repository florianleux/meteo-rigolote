# Flutter Development Standards Documentation

This documentation is organized into two distinct categories to maximize reusability and clarity:

## 📁 Documentation Structure

### `/agnostic/` - Universal Flutter Standards

**Target Audience**: Any Flutter development team or project  
**Language**: English  
**Reusability**: 100% - Framework patterns applicable to any Flutter application

Contains universal Flutter/Dart patterns, architectural guidelines, and best practices that can be adopted by any Flutter project regardless of domain, size, or specific requirements.

### `/specific/` - Project Implementation Guide

**Target Audience**: This specific project (Scrountch)  
**Language**: Mixed (French/English)  
**Reusability**: Project-specific - Contains customizations and configurations

Contains project-specific configurations, design systems, build processes, and implementation details tailored to this particular application.

---

## 🚀 Quick Start Guide

### For New Projects (Using Universal Standards)

1. **Start with Architecture**: Read `/agnostic/architecture_patterns.mdc` to understand the recommended layered architecture
2. **Set Up Standards**: Implement patterns from `/agnostic/flutter_standards.mdc` for consistent code organization
3. **Build UI Components**: Use templates from `/agnostic/widget_guidelines.mdc` for consistent UI patterns
4. **Optimize Performance**: Apply techniques from `/agnostic/performance_rules.mdc` for optimal app performance

### For This Project (Scrountch Implementation)

1. **Follow Universal Standards**: Apply all patterns from `/agnostic/` folder
2. **Project Configuration**: Use `/specific/build-rules.mdc` for build processes and project setup
3. **Design System**: Follow `/specific/design-rules.mdc` for UI styling and branding
4. **Customize as Needed**: Adapt universal patterns to project-specific requirements

---

## 📚 Universal Standards (`/agnostic/`)

### [`architecture_patterns.mdc`](agnostic/architecture_patterns.mdc)

**Universal Flutter/Dart architectural patterns for any application**

- **Layered Architecture**: Clean separation of presentation, business logic, and data layers
- **Service Layer Patterns**: Singleton and static utility service templates
- **State Management Strategies**: Local state, Provider, and Riverpod patterns with decision criteria
- **Navigation Architecture**: Centralized navigation and route generation patterns
- **Dependency Injection**: Service locator and constructor injection patterns
- **Error Handling**: Layered error handling with custom exception hierarchies
- **Data Flow Patterns**: Unidirectional data flow and event handling
- **Testing Architecture**: Unit, widget, and integration testing templates

**When to Use**: Any Flutter project requiring scalable architecture patterns

### [`flutter_standards.mdc`](agnostic/flutter_standards.mdc)

**Universal Flutter/Dart coding standards and best practices**

- **Project Architecture**: Standard folder structure and file naming conventions
- **Widget Patterns**: StatefulWidget vs StatelessWidget guidelines with templates
- **Code Style**: Naming conventions, method organization, and documentation standards
- **Performance Optimizations**: Widget optimization and memory management rules
- **State Management**: Recommended patterns for different application sizes
- **Reusable Components**: Navigation, loading, and error display templates
- **Service Layer Patterns**: API service and navigation service templates
- **Testing Standards**: Widget and service testing templates with examples
- **Version Management**: Semantic versioning with automated build number increments

**When to Use**: Establishing coding standards for any Flutter development team

### [`performance_rules.mdc`](agnostic/performance_rules.mdc)

**Universal Flutter/Dart performance optimization patterns**

- **Widget Performance**: ValueListenableBuilder patterns and const constructor optimization
- **Memory Management**: Resource disposal patterns and async operation safety
- **List Performance**: ListView optimization and key usage for large datasets
- **Image & Asset Optimization**: Efficient image loading and asset preloading strategies
- **Build Method Optimization**: Separating static and dynamic content for minimal rebuilds
- **Theme Performance**: Efficient theme access patterns
- **State Management Performance**: Efficient setState usage and state splitting strategies
- **Performance Monitoring**: Profiling tools and automated performance testing

**When to Use**: Optimizing performance in any Flutter application

### [`widget_guidelines.mdc`](agnostic/widget_guidelines.mdc)

**Universal Flutter widget patterns, UI component standards, and homepage footer guidelines**

- **Homepage Footer Standards**: Copyright and version display patterns for main screens
- **UI Component Patterns**: Reusable widget templates and consistency guidelines
- **Brand Integration**: Font and styling consistency across components

- **Widget Hierarchy**: Screen structure templates and composition rules
- **Reusable Patterns**: Header, loading, error display, and empty state components
- **Input Widget Patterns**: Form fields, dropdowns, and input validation templates
- **List & Card Patterns**: Consistent list items and card layouts
- **Dialog & Modal Patterns**: Alert dialogs, confirmation dialogs, and bottom sheets
- **Responsive Design**: Breakpoint systems and adaptive layouts
- **Performance Optimization**: Const widget usage and ValueListenableBuilder patterns

**When to Use**: Creating consistent UI components for any Flutter application

---

## 🏗️ Project-Specific Implementation (`/specific/`)

### [`build-rules.mdc`](specific/build-rules.mdc)

**Scrountch project build processes and development workflows**

- **Build Scripts**: Required build commands and NDK configuration
- **Development Process**: Git workflow, commit standards, and testing requirements
- **Project Structure**: Specific folder organization and file locations
- **Troubleshooting**: Common build issues and resolution steps
- **Performance Metrics**: Expected build times and APK sizes
- **Maintenance**: Dependency updates and cleanup procedures
- **Version Management**: Automated build number increments and semantic versioning

**When to Use**: Setting up development environment for Scrountch project

### [`versioning-rules.mdc`](specific/versioning-rules.mdc)

**Scrountch automatic version management and release workflow**

- **Semantic Versioning**: MAJOR.MINOR.PATCH+BUILD format with clear increment rules
- **Automated Scripts**: Build number auto-increment and manual version bumping
- **Git Integration**: Automatic tagging and commit workflows
- **Release Management**: Version display widgets and changelog generation
- **Build Integration**: Seamless integration with existing build scripts

**When to Use**: Managing releases and version tracking for Scrountch application

### [`design-rules.mdc`](specific/design-rules.mdc)

**Scrountch application design system and UI standards**

- **Design Philosophy**: "Jaune Bold" visual direction and brand guidelines
- **Color Palette**: Project-specific color schemes and usage rules
- **Typography**: Custom font usage (Dela Gothic One, Chivo) and text styles
- **Button System**: Three-variant button system with specific styling
- **Screen Structure**: Standardized layout patterns and spacing rules
- **Form Components**: Custom input fields and UI element specifications

**When to Use**: Implementing UI components for Scrountch application

---

## 🔄 Integration Strategy

### How Universal and Specific Work Together

1. **Foundation**: Universal standards provide the architectural foundation and coding practices
2. **Customization**: Project-specific rules customize the visual design and build processes
3. **Consistency**: Universal patterns ensure maintainable, scalable code structure
4. **Branding**: Specific rules ensure consistent visual identity and user experience

### Migration Path for Existing Projects

1. **Assess Current Architecture**: Compare existing code against universal patterns
2. **Identify Gaps**: Determine which universal patterns to adopt
3. **Create Project-Specific Rules**: Document your customizations in `/specific/` folder
4. **Gradual Migration**: Refactor code incrementally using universal templates
5. **Team Training**: Ensure all developers understand both universal and specific standards

---

## 📖 Reading Order Recommendations

### For New Flutter Developers

1. `agnostic/flutter_standards.mdc` - Learn basic Flutter coding standards
2. `agnostic/widget_guidelines.mdc` - Understand UI component patterns
3. `agnostic/architecture_patterns.mdc` - Grasp application architecture concepts
4. `agnostic/performance_rules.mdc` - Master optimization techniques

### For Experienced Flutter Developers

1. `agnostic/architecture_patterns.mdc` - Review architectural approaches
2. `agnostic/performance_rules.mdc` - Learn advanced optimization patterns
3. `agnostic/widget_guidelines.mdc` - Adopt consistent UI patterns
4. `agnostic/flutter_standards.mdc` - Align with coding standards

### For This Project Contributors

1. All `/agnostic/` files - Understand universal foundations
2. `specific/design-rules.mdc` - Learn project visual standards
3. `specific/build-rules.mdc` - Set up development environment

---

## 🤝 Contributing

### To Universal Standards (`/agnostic/`)

- Contributions should be framework-agnostic and applicable to any Flutter project
- Include practical code examples and clear use cases
- Maintain language neutrality (English only)
- Provide decision criteria for choosing between alternatives

### To Project-Specific Rules (`/specific/`)

- Focus on this project's specific needs and customizations
- Document deviations from universal patterns with rationale
- Include project context and implementation details
- Maintain consistency with project goals and constraints

---

## 📊 Success Metrics

### Universal Standards Adoption

- **Code Consistency**: Reduced code review time due to standardized patterns
- **Developer Onboarding**: Faster new team member integration
- **Maintainability**: Easier code maintenance and feature development
- **Performance**: Measurable performance improvements using optimization patterns

### Project-Specific Implementation

- **Design Consistency**: Uniform visual experience across all screens
- **Build Reliability**: Consistent, reproducible build processes
- **Development Velocity**: Faster feature development using established patterns
- **Quality Assurance**: Reduced bugs through standardized practices

---

**Last Updated**: January 2025  
**Documentation Version**: 2.0 - Reorganized for Universal Reusability

_This documentation structure enables both universal Flutter development best practices and project-specific implementation guidance, maximizing reusability while maintaining project-specific customizations._
