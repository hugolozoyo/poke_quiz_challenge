# frozen_string_literal: true

require 'pagy/extras/overflow'
require 'pagy/extras/bootstrap'
require 'pagy/extras/metadata'

Pagy::DEFAULT[:items] = 10
Pagy::DEFAULT[:overflow] = :empty_page
Pagy::DEFAULT[:metadata] = %i[count page items pages next prev]
