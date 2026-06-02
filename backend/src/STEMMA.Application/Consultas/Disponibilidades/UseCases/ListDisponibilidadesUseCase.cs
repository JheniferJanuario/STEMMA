using STEMMA.Application.Consultas.Disponibilidades.DTOs.Responses;
using STEMMA.Application.Consultas.Disponibilidades.Mappers;
using STEMMA.Domain.Consultas.Repositories;

namespace STEMMA.Application.Consultas.Disponibilidades.UseCases;

public class ListDisponibilidadesUseCase
{
    private readonly IDisponibilidadeRepository _repository;

    public ListDisponibilidadesUseCase(
        IDisponibilidadeRepository repository)
    {
        _repository = repository;
    }

    public async Task<List<DisponibilidadeResponse>> ExecuteAsync()
    {
        var disponibilidades =
            await _repository.ListarAsync();

        return DisponibilidadeMapper
            .ToResponseList(disponibilidades);
    }
}